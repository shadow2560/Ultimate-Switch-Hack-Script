from .controllers import Controller, any_pressed as _any_pressed


class Player:
    """Represents a player.
    You shouldn't instantiate this yourself.
    Rather, access Player objects via
    ``nx.p1``, ``nx.p2``, ... ``nx.p8``.

    Attributes
    ----------
    number: int
        The player's number, e.g. Player 1's number is 1.
    controller: :class:`Controller`
        The player's controller.

    In addition, a Player has several properties depending on
    the type of :class:`Controller` they are using.
    To begin with, a Player will have a property that points to
    a :class:`Button` for each of the Buttons their Controller has.
    These properties can return ``None`` if a Button is not available
    on the Controller used by the Player.
    Furthermore, a Player will always have the properties ``left``,
    ``right``, ``up``, ``down`` and ``stick``. These work similar
    to the ones found in the Controller classes.
    Finally, a Player can also have the properties ``left_stick``,
    ``right_stick``, ``left_joycon`` and ``right_joycon`` if their
    controller has these attributes.
    """
    def __init__(self, number):
        self.number = number
        self.controller = Controller.from_player(self)

    _extra_controller_attributes = ('left', 'right', 'up', 'down', 'stick', 'left_stick',
                                    'right_stick', 'left_joycon', 'right_joycon')

    def __getattr__(self, item):
        if item.endswith('_button') or item in self._extra_controller_attributes:
            try:
                return getattr(self.controller, item)
            except AttributeError:
                return None

    def any_pressed(self, *buttons, refresh_input=False):
        return _any_pressed(self, *buttons, refresh_input=refresh_input)


p1 = Player(1)
p2 = Player(2)
p3 = Player(3)
p4 = Player(4)
p5 = Player(5)
p6 = Player(6)
p7 = Player(7)
p8 = Player(8)
