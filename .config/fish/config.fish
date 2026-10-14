if status is-interactive
    # Commands to run in interactive sessions can go here
end

# opencode
fish_add_path /home/glenn/.opencode/bin
# >>> mise:activate >>> managed by mise — do not edit between markers
if status is-interactive
    mise activate fish | source
else
    mise activate fish --shims | source
end
# <<< mise:activate <<<
