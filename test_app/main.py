from kivy.app import App
from kivy.uix.label import Label
print("hell")

class MyApp(App):
    def build(self):
        return Label(text="Updated from Android app")

if __name__ == "__main__":
    MyApp().run()
