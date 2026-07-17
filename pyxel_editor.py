import sys

import pyxel


original_init = pyxel.init


def scaled_init(width, height, **kwargs):
    kwargs["display_scale"] = 3
    return original_init(width, height, **kwargs)


pyxel.init = scaled_init

from pyxel.editor import App


resource = sys.argv[1] if len(sys.argv) > 1 else "my_resource.pyxres"

App(resource, "image")
