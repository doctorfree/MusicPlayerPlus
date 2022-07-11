"""Quiet the verbose debug messages from `the` when running `beet -v`."""

from beets import plugins, ui


class QuietThe(plugins.BeetsPlugin):
    def __init__(self, name=None):
        super().__init__(name=name)

        self.register_listener("pluginload", self.loaded)

    def loaded(self):
        for plugin in plugins.find_plugins():
            if plugin.name == "the":
                plugin.template_funcs['the'] = lambda text: the_template_func(plugin, text)
                break
            elif plugin.name == "kergoth":
                plugin.the = lambda text: the_template_func(plugin, text)
        else:
            raise ui.UserError(f"'the' plugin is required for {self.name}")


# Copied from the.py, removing the self._log.debug()
def the_template_func(self, text):
    if not self.patterns:
        return text
    if text:
        for p in self.patterns:
            r = self.unthe(text, p)
            if r != text:
                break
        return r
    else:
        return ""
