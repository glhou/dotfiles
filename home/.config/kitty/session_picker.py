import shutil
from pathlib import Path

SESSION_DIR = Path.home() / "kitty-sessions"
SESSION_EXTENSIONS = {".kitty-session", ".kitty_session", ".session"}


def find_fzf() -> str | None:
    return (
        shutil.which("fzf")
        or ("/opt/homebrew/bin/fzf" if Path("/opt/homebrew/bin/fzf").exists() else None)
        or ("/usr/local/bin/fzf" if Path("/usr/local/bin/fzf").exists() else None)
    )
