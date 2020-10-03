from .players import *
from .controllers import ButtonGroup, refresh_inputs
from .touch import screen as touchscreen
from .title import *


class _Titles:
    def __init__(self):
        self._titles = {}

    def __getitem__(self, title_id):
        if title_id in self._titles:
            return self._titles[title_id]
        _title = Title(title_id)
        self._titles[title_id] = _title
        return _title


titles = _Titles()
