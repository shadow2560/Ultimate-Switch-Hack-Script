import imguihelper
import imgui

class NXRenderer(object):
    def __init__(self):
        imgui.create_context()
        self.io = imgui.get_io()
        self.io.delta_time = 1.0 / 60.0
        imguihelper.initialize()

    def render(self):
        imguihelper.render()

    def handleinputs(self):
        imguihelper.handleinputs()

    def shutdown(self):
        imguihelper.shutdown()
        imgui.destroy_context()