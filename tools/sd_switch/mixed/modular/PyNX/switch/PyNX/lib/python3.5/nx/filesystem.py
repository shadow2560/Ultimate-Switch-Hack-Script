import pathlib
import shutil
import _nx

from . import users


SAVEDATA_BASE_PATH = 'save:/'
ROMFS_BASE_PATH = 'romfs:/'


mounted_romfs = None
mounted_savedata = None


class FileSystem:
    """Represents a filesystem.

    Attributes
    ----------
    base_path: pathlib.Path
        The base path of the filesystem."""
    def __init__(self, base_path: str):
        self.base_path = pathlib.Path(base_path)

    def open(self, file_path: str, mode='r', buffering=-1, encoding=None,
             errors=None, newline=None):
        """Opens a file given a file path and returns a file-like object.
        Apart from the ``file_path: str`` parameter, this method works
        the same way as ``pathlib.Path.open``, thus it works pretty much
        the same way as the ``open`` function.
        """
        return self.base_path.joinpath(file_path).open(mode=mode, buffering=buffering,
                                                       encoding=encoding, errors=errors,
                                                       newline=newline)


class MountableFileSystem(FileSystem):
    """Represents a filesystem that is able to be mounted.

    Attributes
    ----------
    base_path: pathlib.Path
        The base path of the filesystem.
    """
    def __init__(self, base_path):
        super().__init__(base_path)

    @property
    def is_mounted(self):
        """Whether or not the filesystem is currently mounted."""
        raise NotImplementedError

    def open(self, file_path: str, mode='r', buffering=-1, encoding=None,
             errors=None, newline=None):
        """Opens a file given a file path and returns a file-like object.
        Apart from the ``file_path: str`` parameter, this method works
        the same way as ``pathlib.Path.open``, thus it works pretty much
        the same way as the ``open`` function.
        """
        if not self.is_mounted:
            self.mount()
        return super().open(file_path, mode=mode, buffering=buffering, encoding=encoding,
                            errors=errors, newline=newline)

    def mount(self):
        """Mounts the filesystem."""
        raise NotImplementedError

    def commit(self):
        """Commits the filesystem."""
        raise NotImplementedError

    def unmount(self):
        """Unmounts the filesystem."""
        raise NotImplementedError

    def __enter__(self):
        self.mount()
        return self

    def __exit__(self, exc_type, exc_val, exc_tb):
        self.commit()
        self.unmount()


class RomFS(MountableFileSystem):
    """Represents the data filesystem of a title.
    Do not instantiate this. Rather, get a RomFS object via
    ``nx.titles[MY_TITLE_ID].romfs``.

    Attributes
    ----------
    title: :class:`Title`
        The title this RomFS belongs to.
    base_path: pathlib.Path
        The base path of the RomFS.
    """
    def __init__(self, title):
        super().__init__(ROMFS_BASE_PATH)
        self.title = title

    @property
    def is_mounted(self):
        """Whether the RomFS is mounted."""
        return self is mounted_romfs

    def mount(self):
        """Yet to be implemented. Mounts the RomFS."""
        raise NotImplementedError  # TODO: implement RomFS.mount

    def unmount(self):
        """Unmounts the mounted RomFS."""
        _nx.fsdev_unmount_device('romfs')

    def __exit__(self, exc_type, exc_val, exc_tb):
        self.unmount()


class Savedata(MountableFileSystem):
    """Represents the savedata filesystem of a title.
    Do not instantiate this. Rather, get a Savedata object via
    ``nx.titles[MY_TITLE_ID].savedata``.

    Attributes
    ----------
    title: :class:`Title`
        The title this Savedata belongs to.
    base_path: pathlib.Path
        The base path of the savedata filesystem.
    """
    def __init__(self, title, user=None):
        super().__init__(SAVEDATA_BASE_PATH)
        self.title = title
        self.user = user if user is not None else users.active_user

    @property
    def is_mounted(self):
        """Whether the savedata filesystem has been mounted."""
        return self is mounted_savedata

    def mount(self):
        """Mounts the savedata filesystem."""
        if self.is_mounted:
            return
        if self.user is None:
            raise RuntimeError("No active user, you need to launch and "
                               "close a game prior to launching HBL.")
        _nx.fs_mount_savedata('save', self.title.id, self.user.id)
        global mounted_savedata  # TODO: consider not using globals
        mounted_savedata = self

    def commit(self):
        """Commits the savedata filesystem."""
        _nx.fsdev_commit_device('save')

    def unmount(self):
        """Unmounts the savedata filesystem."""
        _nx.fsdev_unmount_device('save')

    def backup(self, destination: str=None):
        """Creates a backup of the savedata.
        
        Parameters
        ----------
        destination: str
            Directory path where the backup will be created.
            If the directory doesn't exist already, it will be created.
            The operation will fail if the directory already exists and is not empty.
            Defaults to '/backups/savedata/{title_id}/'.
        """
        title_id = hex(self.title.id)[2:]
        destination = '/backups/savedata/{}/'.format(title_id) if destination is None else destination
        return shutil.copytree(str(self.base_path), destination)
