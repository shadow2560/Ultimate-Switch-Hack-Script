# urls.py
# A part of NonVisual Desktop Access (NVDA)
# This file is covered by the GNU General Public License.
# See the file COPYING for more details.
# Copyright (C) 2012-2022 NV Access Limited, Beqa Gozalishvili, Joseph Lee,
# Babbage B.V., Ethan Holliger, Luke Davis

# Centralized URL constants.
# Primary purpose is to make debugging easier, by allowing test builds to change source locations
# without effecting main repositories.
# Secondary purpose is to make it unnecessary to search code when URLs need to be located/updated.

# The _URLAccessors class is a pseudo-singleton that provides property-based accessors.
# Each self-documenting method returns one URL used by some other part of the add-on.
# The URLs object is what should be imported by consumers. I.E. "from .urls import URLs"
# Individual URLs may then be accessed, for example, as: "URLs.communityFileGetter".

class _URLAccessors(object):
	"""Public accessors for the URL constants in the urls module."""

	@property
	def communityFileGetter(self) -> str:
		"""The portion of the URL before the add-on identifier used to download add-on packages
		from the NV Access add-on store legacy endpoint.
		"""
		return "https://www.nvaccess.org/addonStore/legacy?file="

	@property
	def metadata(self) -> str:
		"""The full URL to the JSON file containing add-ons metadata."""
		return "https://nvdaaddons.github.io/data/addonsData.json"

	@property
	def communityHostedFile(self) -> str:
		"""The base URL for add-on packages that can be downloaded directly from nvda-project.org."""
		return "https://addons.nvda-project.org/files/"

	@property
	def communityAddonsList(self) -> str:
		"""The get.php mechanism provides a list of all add-ons it serves via this URL.
		With the advent of NV Access add-on store, a legacy endpoint is provided instead."""
		return "https://www.nvaccess.org/addonStore/legacy?addonslist"

	@property
	def communitySite(self) -> str:
		"""The URL to the community add-ons site."""
		return "https://addons.nvda-project.org"


URLs = _URLAccessors()
