import shutil
import subprocess
from pathlib import Path

from kitty.boss import Boss

DEFAULT_SESSION = Path.home() / ".config/kitty/default.session"
DEFAULT_SESSION_DIR = Path.home() / ".config/kitty"
SESSION_DIR = Path.home() / "kitty-sessions"
SESSION_EXTENSIONS = {".kitty-session", ".kitty_session", ".session"}


def find_fzf() -> str | None:
    return (
        shutil.which("fzf")
        or ("/opt/homebrew/bin/fzf" if Path("/opt/homebrew/bin/fzf").exists() else None)
        or ("/usr/local/bin/fzf" if Path("/usr/local/bin/fzf").exists() else None)
    )


def session_name(path: Path) -> str:
    for ext in SESSION_EXTENSIONS:
        if path.name.endswith(ext):
            return path.name[: -len(ext)]
    return path.name


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

    if not sessions:
        print(f"No session found in {session_dir}")
        return ""

    entries = {
        path: f"{path.relative_to(session_dir).with_name(session_name(path))}"
        for path in sessions
    }

    if DEFAULT_SESSION.exists():
        entries[DEFAULT_SESSION] = (
            f"{DEFAULT_SESSION.relative_to(DEFAULT_SESSION_DIR).with_name(session_name(DEFAULT_SESSION))}"
        )

    str_entries = "\n".join(f"{name}\t{path}" for path, name in entries.items())

    result = subprocess.run(
        [
            fzf,
            "--prompt=session> ",
            "--layout=reverse",
            "--border=rounded",
            "--info=inline",
            "--color=fg:-1,bg:-1",
            "--color=fg+:-1,bg+:-1",
            "--with-nth=1",
            "--delimiter=\t",
            "--no-multi",
        ],
        input=str_entries,
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
