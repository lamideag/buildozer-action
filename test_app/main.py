from time import  sleep

from kivy.app import App
from kivy.lang import Builder


class MainApp(App):
    def build(self):
        return Builder.load_file("main.kv")


if __name__ == "__main__":
    MainApp().run()
