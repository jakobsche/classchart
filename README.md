# Class Chart

application to view a class inheritance tree containing the selected classes and their ancestors only

Edit the handler TForm1.FormCreate to add a class to your choice, then compile and run the application to get the tree view! You only need to add classes that have no descendants. Missing ancestors are added by the algorithm. Therefore it can happen, that you have to fix errors during compilation by using additional units.

This example also shows, that classes in Object Pascal know their identity. Therefore you can request and use their type information at runtime. This is done here to build the inheritance tree.
