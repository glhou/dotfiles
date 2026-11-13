import shutil
import subprocess
from pathlib import Path

from kitty.boss import Boss

DEFAULT_SESSION = Path.home() / ".config/kitty/default.session"
SESSION_DIR = Path.home() / "kitty-sessions"
SESSION_EXTENSIONS = {".kitty-session", ".kitty_session", ".session"}


def find_fzf() -> str | None:
    return (
        shutil.which("fzf")
        or ("/opt/homebrew/bin/fzf" if Path("/opt/homebrew/bin/fzf").exists() else None)
        or ("/usr/local/bin/fzf" if Path("/usr/local/bin/fzf").exists() else None)
    )


def main(args: list[str]) -> str:
    session_dir = Path(args[1]).expanduser() if len(args) > 1 else SESSION_DIR
    fzf = find_fzf()

    if not fzf:
        print("fzf is not installed or could not be found.")
        return ""

    sessions = sorted(
        (
            path
            for path in session_dir.rglob("*")
            if path.is_file()
            and any(path.name.endswith(ext) for ext in SESSION_EXTENSIONS)
        ),
        key=lambda path: path.name.lower(),
    )

    sessions.append(Path())

    if not sessions:
        print(f"No session found in {session_dir}")
        return ""

    entries = "\n".join(f"{path.relative_to(session_dir)}\t{path}" for path in sessions)

    result = subprocess.run(
        [
            fzf,
            "--prompt=session> ",
            "--height=60%",
            "--layout=reverse",
            "--border=rounded",
            "--info=inline",
            "--with-nth=1",
            "--delimiter=\t",
            "--no-multi",
        ],
        input=entries,
        text=True,
        capture_output=True,
    )

    if result.returncode != 0 or not result.stdout.strip():
        return ""

    selected = result.stdout.strip()
    return selected.split("\t", 1)[1]


def handle_result(
    args: list[str],
    answer: str,
    target_window_id: int,
    boss: Boss,
) -> None:
    if not answer:
        return
    window = boss.window_id_map.get(target_window_id)
    if window is None:
        return

    boss.call_remote_control(window, ("action", "goto_session", answer))
