from .filesystem import RomFS, Savedata


class Title:
    """Represents a title that is installed on or inserted into the Switch.
    Do not instantiate this. Rather, get a Title object via
    ``nx.titles[MY_TITLE_ID]``

    Attributes
    ----------
    id: int
        The title ID.
    romfs: :class:`RomFS`
        The title's ROM filesystem.
    savedata: :class:`Savedata`
        The title's savedata filesystem.
    """
    def __init__(self, id: int):
        self.id = id
        self.romfs = RomFS(self)
        self.savedata = Savedata(self)
