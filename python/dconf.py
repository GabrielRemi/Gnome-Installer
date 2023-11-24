"""handles all the logic needed to create a shell script, which 
sets on a machine all the keys with dconf that were set when this script
was run. It first loops over all extensions, finds all the keys and its values. 
Then it writes a script which sets all the key values to those values 
which were found when running this script. This way one can run the script 
on one machine and copy all of the settings to another one"""
import os
#from dataclasses import dataclass, field

EXTENSIONS_PATH: str = "/org/gnome/shell/extensions/"


class DConf:
    """A class that stores all keys from all extensions"""

    def __init__(self):
        cmd: str = f"dconf list {EXTENSIONS_PATH}"
        self.__extensions_names: list[str] = os.popen(cmd).read().splitlines()
        self.__extensions: list[Folder] = [
            Folder(i, EXTENSIONS_PATH) for i in self.__extensions_names]

    @property
    def extensions(self):
        """getter for extension list"""
        return self.__extensions


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
            value = os.popen(txt).read()
            cmd += f"dconf write {self.path}{i} {value}"


if __name__ == "__main__":
    dconf = DConf()
    print(dconf.extensions[8].keys, dconf.extensions[8].folders)
