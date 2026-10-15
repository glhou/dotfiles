local M = {}

local function push_to_quick_list(json)
  local items = {}
  for _, comment in ipairs(json) do
    table.insert(items, {
      filename = comment.path,
      lnum = comment.line,
      col = 1,
      text = string.format('[PR] %s: %s', comment.author, comment.body:gsub('\n', ' ')),
    })
  end

  vim.fn.setqflist({}, ' ', {
    title = 'PR review comments',
    items = items,
  })

  vim.cmd 'copen'
end

function M.get_pr_comments()
  local repo = vim.fn
    .system({
      'gh',
      'repo',
      'view',
      '--json',
      'nameWithOwner',
      '--jq',
      '.nameWithOwner',
    })
    :gsub('%s+$', '')

  local owner, name = repo:match '([^/]+)/([^/]+)'
  local branch = vim.fn
    .system({
      'jj',
      'log',
      '-r',
      'dev@origin..@',
      '-T',
      'local_bookmarks',
      '--no-graph',
    })
    :gsub('%s+', '')
  local query = [[
  query ($owner: String!, $name: String!, $branch: String!) {
  repository(owner: $owner, name: $name) {
    pullRequests(first: 1, headRefName: $branch, states: OPEN) {
      nodes {
        number
        title
        reviews(first: 100){
          nodes {
            author {
              login
            }
            state
          }
        }
        reviewThreads(first: 100) {
          nodes {
            isResolved
            originalLine
            path
            comments(first: 100) {
              nodes {
                author {
                  login
                }
                body
              }
            }
          }
        }
      }
    }
  }
}
      ]]
  local jq_query = [[
[
.data.repository.pullRequests.nodes[]
| .reviewThreads.nodes[]
| select(.isResolved == false)
| .comments.nodes[]
| {
line: (.line // .originalLine),
path: .path,
author: .author.login,
body: .body
}
]
  ]]
  if owner == nil or name == nil or branch == nil then return nil end

  local json = vim.fn.system {
    'gh',
    'api',
    'graphql',
    '-F',
    'owner=' .. owner,
    '-F',
    'name=' .. name,
    '-F',
    'branch=' .. branch,
    '-f',
    'query=' .. query,
    '--jq=' .. jq_query,
  }

  local data = vim.json.decode(json)
  push_to_quick_list(data)

  return nil
end

return M
