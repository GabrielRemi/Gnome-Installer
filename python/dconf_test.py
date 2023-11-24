"""Test script of dconf.py"""
from dconf import *

def test_folder():
    """tests the functionality of folder class"""
    folder = Folder("nightthemeswitcher", EXTENSIONS_PATH)
    assert folder.name == "nightthemeswitcher/"
    assert folder.path == f"{EXTENSIONS_PATH}nightthemeswitcher/"
    
    folder = Folder("nightthemeswitcher", EXTENSIONS_PATH[:-1])
    assert folder.name == "nightthemeswitcher/"
    assert folder.path == f"{EXTENSIONS_PATH[:-1]}/nightthemeswitcher/"
    
    print(folder.keys)
    print([i.keys for i in folder.folders])
    

if __name__ == "__main__":
    test_folder()