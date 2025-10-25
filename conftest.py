import os
import sys

ROOT_DIR = os.path.dirname(__file__)
SRC_PATH = os.path.join(ROOT_DIR, "src")

if SRC_PATH not in sys.path:
    sys.path.insert(0, SRC_PATH)
