from .controllers import Button
from .players import p1
from .utils import bit

import _nx


class Touch:
    """Represents a touch point.

    Attributes
    ----------
    x: float
        The x coordinate of the touch.
    y: float
        The y coordinate of the touch.
    dx: float
        The width of the touch in pixels.
    dy: float
        The height of the touch in pixels.
    angle: float
        The angle of the touch.
    """
    def __init__(self, x, y, dx, dy, angle):
        self.x = x
        self.y = y
        self.dx = dx
        self.dy = dy
        self.angle = angle

    def __repr__(self):
        return "Touch(x={0.x}, y={0.y}, dx={0.dx}, dy={0.dy}, angle={0.angle})".format(self)


class TouchScreen(Button):
    """Represents the Switch's touchscreen."""
    def __init__(self):
        super().__init__(p1, bit(26))

    @property
    def touches(self):
        """Returns a tuple of :class:`Touch` objects that
        represent where and how the touchscreen is touched.
        Can return an empty tuple."""
        _touches = _nx.hid_get_touches()
        touch_list = []
        for touch in _touches:
            touch_list.append(Touch(*touch))
        return touch_list


screen = TouchScreen()
