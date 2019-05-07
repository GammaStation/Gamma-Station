/*ALL DEFINES RELATED TO CONSTRUCTION, CONSTRUCTING THINGS, OR CONSTRUCTED OBJECTS GO HERE*/

//tablecrafting defines
#define CAT_NONE        ""
#define CAT_WEAPONRY    "Weaponry"
#define CAT_WEAPON      "Weapons"
#define CAT_AMMO        "Ammunition"
#define CAT_ASSEMBLY    "Assemply"
#define CAT_ROBOT       "Robots"
#define CAT_MISC        "Misc"
#define CAT_PRIMAL      "Tribal"
#define CAT_CLOTHING    "Clothing"
#define CAT_FOOD        "Foods"
#define CAT_BREAD       "Breads"
#define CAT_BURGER      "Burgers"
#define CAT_CAKE        "Cakes"
#define CAT_EGG         "Egg-Based Food"
#define CAT_MEAT        "Meats"
#define CAT_MISCFOOD    "Misc. Food"
#define CAT_PASTRY      "Pastries"
#define CAT_PIE         "Pies"
#define CAT_PIZZA       "Pizzas"
#define CAT_SALAD       "Salads"
#define CAT_SANDWICH    "Sandwiches"
#define CAT_SOUP        "Soups"
#define CAT_SPAGHETTI   "Spaghettis"

// Painter turf-painting related stuff.
// A list of icon states you can paint into in format name -> icon_state.
#define PAINTER_FLOOR_NAME2ICONSTATE list("Grey full" = "floor", \
                                          "Red full" = "redfull", \
                                          "Grey with red strip" = "red", \
                                          "Grey with red corner" = "redcorner", \
                                          "Blue full" = "bluefull", \
                                          "Grey with blue strip" = "blue", \
                                          "Grey with blue corner" = "bluecorner", \
                                          "Green full" = "greenfull", \
                                          "Grey with green strip" = "green", \
                                          "Grey with green corner" = "greencorner", \
                                          "Yellow full" = "yellowfull", \
                                          "Grey with yellow strip" = "yellow", \
                                          "Grey with yellow corner" = "yellowcorner", \
                                          "Purple full" = "purplefull", \
                                          "Grey with purple strip" = "purple", \
                                          "Grey with purple corner" = "purplecorner", \
                                          "Orange full" = "orangefull", \
                                          "Grey with orange strip" = "orange", \
                                          "Grey with orange corner" = "orangecorner", \
                                          "Grey with dark strip" = "black", \
                                          "Grey with dark corner" = "blackcorner", \
                                          "Grey with white strip" = "whitehall", \
                                          "Grey with white corner" = "whitecorner", \
                                          "White full" = "white", \
                                          "Pink full" = "whiteredfull", \
                                          "White with pink strip" = "whitered", \
                                          "White with pink corner" = "whiteredcorner", \
                                          "Light Blue full" = "whitebluefull", \
                                          "White with light blue strip" = "whiteblue", \
                                          "White with light blue corner" = "whitebluecorner", \
                                          "Light Green full" = "whitegreenfull", \
                                          "White with light green strip" = "whitegreen", \
                                          "White with light green corner" = "whitegreencorner", \
                                          "Light Yellow full" = "whiteyellowfull", \
                                          "White with light yellow strip" = "whiteyellow", \
                                          "White with light yellow corner" = "whiteyellowcorner", \
                                          "Light Purpler full" = "whitepurplefull", \
                                          "White with light purple strip" = "whitepurple", \
                                          "White with light purple corner" = "whitepurplecorner", \
                                          "White and Pink checkers" = "redchecker", \
                                          "White and Light Blue checkers" = "bluechecker", \
                                          "White and Light Green checkers" = "greenchecker", \
                                          "White and Light Yellow checkers" = "yellowchecker", \
                                          "White and Light Purple checkers" = "purplechecker", \
                                          "White and Black checkers" = "blackchecker", \
                                          "Dark full" = "dark", \
                                          "Dark Red full" = "darkredfull", \
                                          "Dark with dark red strip" = "darkred", \
                                          "Dark with dark red corner" = "darkredcorners", \
                                          "Dark Blue full" = "darkbluefull", \
                                          "Dark with dark blue strip" = "darkblue", \
                                          "Dark with dark blue corner" = "darkbluecorners", \
                                          "Dark Green full" = "darkgreenfull", \
                                          "Dark with dark green strip" = "darkgreen", \
                                          "Dark with dark green corner" = "darkgreencorners", \
                                          "Dark Yellow full" = "darkyellowfull", \
                                          "Dark with dark yellow strip" = "darkyellow", \
                                          "Dark with dark yellow corner" = "darkyellowcorners", \
                                          "Dark Purple full" = "darkpurplefull", \
                                          "Dark with dark purple strip" = "darkpurple", \
                                          "Dark with dark purple corner" = "darkpurplecorners", \
                                          )

// A list of icon states you can paint, should contain at least all icon states from list above.
#define PAINTER_FLOOR_ICON_STATES list("floor", \
                                       "redfull", \
                                       "red", \
                                       "redcorner", \
                                       "bluefull", \
                                       "blue", \
                                       "bluecorner", \
                                       "greenfull", \
                                       "green", \
                                       "greencorner", \
                                       "yellowfull", \
                                       "yellow", \
                                       "yellowcorner", \
                                       "purplefull", \
                                       "purple", \
                                       "purplecorner", \
                                       "orangefull", \
                                       "orange", \
                                       "orangecorner", \
                                       "black", \
                                       "blackcorner", \
                                       "whitehall", \
                                       "whitecorner", \
                                       "white", \
                                       "whiteredfull", \
                                       "whitered", \
                                       "whiteredcorner", \
                                       "whitebluefull", \
                                       "whiteblue", \
                                       "whitebluecorner", \
                                       "whitegreenfull", \
                                       "whitegreen", \
                                       "whitegreencorner", \
                                       "whiteyellowfull", \
                                       "whiteyellow", \
                                       "whiteyellowcorner", \
                                       "whitepurplefull", \
                                       "whitepurple", \
                                       "whitepurplecorner", \
                                       "redchecker", \
                                       "bluechecker", \
                                       "greenchecker", \
                                       "yellowchecker", \
                                       "purplechecker", \
                                       "blackchecker", \
                                       "dark", \
                                       "darkredfull", \
                                       "darkred", \
                                       "darkredcorners", \
                                       "darkbluefull", \
                                       "darkblue", \
                                       "darkbluecorners", \
                                       "darkgreenfull", \
                                       "darkgreen", \
                                       "darkgreencorners", \
                                       "darkyellowfull", \
                                       "darkyellow", \
                                       "darkyellowcorners", \
                                       "darkpurplefull", \
                                       "darkpurple", \
                                       "darkpurplecorners", \
                                       )