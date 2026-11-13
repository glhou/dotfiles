from kitty.boss import Boss

import shutil
import subprocess
from pathlib import Path

SESSION_DIR = Path.home() / "kitty-sessions"
SESSION_EXTENSIONS = {".kitty-session", ".kitty_session", ".session"}

def main(args: list[str]) -> str:
    
