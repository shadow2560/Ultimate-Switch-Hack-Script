import _nx
import warnings


_nx.account_initialize()


class User:
    """Represents a user who is registered on the Switch.

    Attributes
    ----------
    id: int
        The user ID.
    """
    def __init__(self, id):
        self.id = id

    @property
    def is_active(self):
        """
        :returns: Whether the specified user is the current active user
        :rtype: bool
        """
        return self.id == active_user.id


try:
    active_user = User(_nx.account_get_active_user())
except OSError:
    warnings.warn(Warning, "No active user, you need to launch and close a game prior to launching HBL.")
    active_user = None
