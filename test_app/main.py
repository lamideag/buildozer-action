""
Hello World Simple app for testing Buildozer Action.

Creates a Kivy application using the main.kv file.
""

From the import application kivy.app
From kivy.lang import constructor




Main application class (application):
    Defensive construction (self):
        Return Builder.load_file("main.kv")


If __name__ == "__main__":
    MainApp().run()
