#define MAX_PILL_SPRITE 20
#define MAX_BOTTLE_SPRITE 3

#define SOLID 1
#define LIQUID 2
#define GAS 3

#define FOOD_METABOLISM 0.4
#define DRINK_METABOLISM 0.8

#define REAGENTS_OVERDOSE 30

#define REM REAGENTS_EFFECT_MULTIPLIER

// How many units of reagent are consumed per tick, by default.
#define REAGENTS_METABOLISM 0.2

// By defining the effect multiplier this way, it'll exactly adjust
// all effects according to how they originally were with the 0.4 metabolism
#define REAGENTS_EFFECT_MULTIPLIER REAGENTS_METABOLISM / 0.4
