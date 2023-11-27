"""handles all the logic needed to create a shell script, which 
sets on a machine all the keys with dconf that were set when this script
was run. It first loops over all extensions, finds all the keys and its values. 
Then it writes a script which sets all the key values to those values 
which were found when running this script. This way one can run the script 
on one machine and copy all of the settings to another one"""
import os, sys
#from dataclasses import dataclass, field
from filemanagement import get_extension_names_from_file

EXTENSIONS_PATH: str = "/org/gnome/shell/extensions/"
os.chdir(os.path.dirname(__file__))

class DConf:
    """A class that stores all keys from all extensions. if a list of 
    extensions is given instead, do it only for those"""

    def __init__(self, extension_list: list[str] | None = None):
        cmd: str = f"dconf list {EXTENSIONS_PATH}"
        self.__extensions_names: list[str] = os.popen(cmd).read().splitlines()
        self.__extensions: list[Folder] = []
        
        if extension_list is None:
            self.__extensions = [
                Folder(i, EXTENSIONS_PATH) for i in self.__extensions_names]
        else:
            for i in self.__extensions_names:
                if i in extension_list:
                    self.__extensions.append(Folder(i, EXTENSIONS_PATH))

    @property
    def extensions(self):
        """getter for extension list"""
        return self.__extensions
    
    def get_command(self) -> list[str]:
        """make a list of strings where for every string every line is a bash command to 
        set the key values"""
        cmd: list[str] = []
        for i in self.extensions:
            cmd.append(c := i.get_command())
            with open(f"../extensions/{i.name[:-1]}.sh", "w", encoding="UTF-8") as file:
                file.write(c)
            
        return cmd


class Folder:
    """Class that stores information about an extension like its current key values"""

    def __init__(self, name: str, directory: str):
        if name[-1] == "/":
            self.__name = name
        else:
            self.__name = f"{name}/"
        if directory[-1] == r"/":
            self.__path = f"{directory}{self.name}"
        else:
            self.__path = f"{directory}/{self.name}"

        self.__keys: list[str] = []
        self.__folders: list[Folder] = []
        self.__get_keys()

    def __str__(self) -> str:
        return self.name

    def __repr__(self) -> str:
        return self.name

    @property
    def name(self):
        """return name of folder"""
        return self.__name

    @property
    def path(self):
        """return path of folder"""
        return self.__path

    @property
    def keys(self):
        """getter of keys"""
        return self.__keys

    @property
    def folders(self):
        """getter of folders"""
        return self.__folders

    def __get_keys(self) -> None:
        """fill the arrays with keys. if an elemenent is a folder, add it to
        folders"""
        cmd: str = f"dconf list {self.path}"
        lines = os.popen(cmd).read().splitlines()
        for i in lines:
            if i[-1] != "/":
                self.__keys.append(i)
            else:
                self.__folders.append(Folder(i, self.__path))
                
    def get_command(self) -> str:
        """writes string, where to every key a command to settings the value is written"""
        cmd: str = ""
        for i in self.folders:
            cmd += i.get_command()
            
        for i in self.keys:
            txt = f"dconf read {self.path}{i}"
            value = os.popen(txt).read().replace("\n", "")
            cmd += f'dconf write {self.path}{i} "{value}"\n'
            
        return cmd


if __name__ == "__main__":
    extension_list: None | list[str] = None
    if len(sys.argv) > 1:
        extension_list = get_extension_names_from_file(sys.argv[1])

    dconf = DConf(extension_list)
    for i in dconf.get_command():
        print(i, end="\n\n")