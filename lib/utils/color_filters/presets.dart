import 'addons.dart';
import 'colorfilter_generator.dart';

/// Preset filters that can be used directly
class PresetFilters {
  /// NoFilter: No filter
  static final ColorFilterGenerator none = ColorFilterGenerator(
    name: 'None',
    filters: <List<double>>[],
  );

  /// Clarendon: adds light to lighter areas and dark to darker areas
  static final ColorFilterGenerator clarendon = ColorFilterGenerator(
    name: 'Clarendon',
    filters: <List<double>>[
      ColorFilterAddons.brightness(.1),
      ColorFilterAddons.contrast(.1),
      ColorFilterAddons.saturation(.15),
    ],
  );

  /// Gingham: Vintage-inspired, taking some color out
  static final ColorFilterGenerator gingham = ColorFilterGenerator(
    name: 'Gingham',
    filters: <List<double>>[
      ColorFilterAddons.sepia(.04),
      ColorFilterAddons.contrast(-.15),
    ],
  );

  /// Moon: B/W, increase brightness and decrease contrast
  static final ColorFilterGenerator moon = ColorFilterGenerator(
    name: 'Moon',
    filters: <List<double>>[
      ColorFilterAddons.grayscale(),
      ColorFilterAddons.contrast(-.04),
      ColorFilterAddons.brightness(0.1),
    ],
  );

  /// Lark: Brightens and intensifies colours but not red hues
  static final ColorFilterGenerator lark = ColorFilterGenerator(
    name: 'Lark',
    filters: <List<double>>[
      ColorFilterAddons.brightness(0.08),
      ColorFilterAddons.grayscale(),
      ColorFilterAddons.contrast(-.04),
    ],
  );

  /// Reyes: a vintage filter, gives your photos a “dusty” look
  static final ColorFilterGenerator reyes = ColorFilterGenerator(
    name: 'Reyes',
    filters: <List<double>>[
      ColorFilterAddons.sepia(0.4),
      ColorFilterAddons.brightness(0.13),
      ColorFilterAddons.contrast(-.05),
    ],
  );

  /// Juno: Brightens colors, and intensifies red and yellow hues
  static final ColorFilterGenerator juno = ColorFilterGenerator(
    name: 'Juno',
    filters: <List<double>>[
      ColorFilterAddons.rgbScale(1.01, 1.04, 1),
      ColorFilterAddons.saturation(0.3),
    ],
  );

  /// Slumber: Desaturates the image as well as adds haze for a retro, dreamy look – with an emphasis on blacks and blues
  static final ColorFilterGenerator slumber = ColorFilterGenerator(
    name: 'Slumber',
    filters: <List<double>>[
      ColorFilterAddons.brightness(.1),
      ColorFilterAddons.saturation(-0.5),
    ],
  );

  /// Crema: Adds a creamy look that both warms and cools the image
  static final ColorFilterGenerator crema = ColorFilterGenerator(
    name: 'Crema',
    filters: <List<double>>[
      ColorFilterAddons.rgbScale(1.04, 1, 1.02),
      ColorFilterAddons.saturation(-0.05),
    ],
  );

  /// Ludwig: A slight hint of desaturation that also enhances light
  static final ColorFilterGenerator ludwig = ColorFilterGenerator(
    name: 'Ludwig',
    filters: <List<double>>[
      ColorFilterAddons.brightness(.05),
      ColorFilterAddons.saturation(-0.03),
    ],
  );

  /// Aden: This filter gives a blue/pink natural look
  static final ColorFilterGenerator aden = ColorFilterGenerator(
    name: 'Aden',
    filters: <List<double>>[
      ColorFilterAddons.colorOverlay(228, 130, 225, 0.13),
      ColorFilterAddons.saturation(-0.2),
    ],
  );

  /// Perpetua: Adding a pastel look, this filter is ideal for portraits
  static final ColorFilterGenerator perpetua = ColorFilterGenerator(
    name: 'Perpetua',
    filters: <List<double>>[
      ColorFilterAddons.rgbScale(1.05, 1.1, 1),
    ],
  );

  /// Amaro: Adds light to an image, with the focus on the centre
  static final ColorFilterGenerator amaro = ColorFilterGenerator(
    name: 'Amaro',
    filters: <List<double>>[
      ColorFilterAddons.saturation(0.3),
      ColorFilterAddons.brightness(0.15),
    ],
  );

  /// Mayfair: Applies a warm pink tone, subtle vignetting to brighten the photograph center and a thin black border
  static final ColorFilterGenerator mayfair = ColorFilterGenerator(
    name: 'Mayfair',
    filters: <List<double>>[
      ColorFilterAddons.colorOverlay(230, 115, 108, 0.05),
      ColorFilterAddons.saturation(0.15),
    ],
  );

  /// Rise: Adds a 'glow' to the image, with softer lighting of the subject
  static final ColorFilterGenerator rise = ColorFilterGenerator(
    name: 'Rise',
    filters: <List<double>>[
      ColorFilterAddons.colorOverlay(255, 170, 0, 0.1),
      ColorFilterAddons.brightness(0.09),
      ColorFilterAddons.saturation(0.1),
    ],
  );

  /// Hudson: Creates an 'icy' illusion with heightened shadows, cool tint and dodged center
  static final ColorFilterGenerator hudson = ColorFilterGenerator(
    name: 'Hudson',
    filters: <List<double>>[
      ColorFilterAddons.rgbScale(1, 1, 1.25),
      ColorFilterAddons.contrast(0.1),
      ColorFilterAddons.brightness(0.15),
    ],
  );

  /// Valencia: Fades the image by increasing exposure and warming the colors, to give it an antique feel
  static final ColorFilterGenerator valencia = ColorFilterGenerator(
    name: 'Valencia',
    filters: <List<double>>[
      ColorFilterAddons.colorOverlay(255, 225, 80, 0.08),
      ColorFilterAddons.saturation(0.1),
      ColorFilterAddons.contrast(0.05),
    ],
  );

  /// X-Pro II: Increases color vibrance with a golden tint, high contrast and slight vignette added to the edges
  static final ColorFilterGenerator xProII = ColorFilterGenerator(
    name: 'X-Pro II',
    filters: <List<double>>[
      ColorFilterAddons.colorOverlay(255, 255, 0, 0.07),
      ColorFilterAddons.saturation(0.2),
      ColorFilterAddons.contrast(0.15),
    ],
  );

  /// Sierra: Gives a faded, softer look
  static final ColorFilterGenerator sierra = ColorFilterGenerator(
    name: 'Sierra',
    filters: <List<double>>[
      ColorFilterAddons.contrast(-0.15),
      ColorFilterAddons.saturation(0.1),
    ],
  );

  /// Willow: A monochromatic filter with subtle purple tones and a translucent white border
  static final ColorFilterGenerator willow = ColorFilterGenerator(
    name: 'Willow',
    filters: <List<double>>[
      ColorFilterAddons.grayscale(),
      ColorFilterAddons.colorOverlay(100, 28, 210, 0.03),
      ColorFilterAddons.brightness(0.1),
    ],
  );

  /// Lo-Fi: Enriches color and adds strong shadows through the use of saturation and 'warming' the temperature
  static final ColorFilterGenerator loFi = ColorFilterGenerator(
    name: 'Lo-Fi',
    filters: <List<double>>[
      ColorFilterAddons.contrast(0.15),
      ColorFilterAddons.saturation(0.2),
    ],
  );

  /// Inkwell: Direct shift to black and white
  static final ColorFilterGenerator inkwell = ColorFilterGenerator(
    name: 'Inkwell',
    filters: <List<double>>[
      ColorFilterAddons.grayscale(),
    ],
  );

  /// Hefe: Hight contrast and saturation, with a similar effect to Lo-Fi but not quite as dramatic
  static final ColorFilterGenerator hefe = ColorFilterGenerator(
    name: 'Hefe',
    filters: <List<double>>[
      ColorFilterAddons.contrast(0.1),
      ColorFilterAddons.saturation(0.15),
    ],
  );

  /// Nashville: Warms the temperature, lowers contrast and increases exposure to give a light 'pink' tint – making it feel 'nostalgic'
  static final ColorFilterGenerator nashville = ColorFilterGenerator(
    name: 'Nashville',
    filters: <List<double>>[
      ColorFilterAddons.colorOverlay(220, 115, 188, 0.12),
      ColorFilterAddons.contrast(-0.05),
    ],
  );

  /// Stinson: washing out the colors ever so slightly
  static final ColorFilterGenerator stinson = ColorFilterGenerator(
    name: 'Stinson',
    filters: <List<double>>[
      ColorFilterAddons.brightness(0.1),
      ColorFilterAddons.sepia(0.3),
    ],
  );

  /// Vesper: adds a yellow tint that
  static final ColorFilterGenerator vesper = ColorFilterGenerator(
    name: 'Vesper',
    filters: <List<double>>[
      ColorFilterAddons.colorOverlay(255, 225, 0, 0.05),
      ColorFilterAddons.brightness(0.06),
      ColorFilterAddons.contrast(0.06),
    ],
  );

  /// Earlybird: Gives an older look with a sepia tint and warm temperature
  static final ColorFilterGenerator earlybird = ColorFilterGenerator(
    name: 'Earlybird',
    filters: <List<double>>[
      ColorFilterAddons.colorOverlay(255, 165, 40, 0.2),
      ColorFilterAddons.saturation(0.15),
    ],
  );

  /// Brannan: Increases contrast and exposure and adds a metallic tint
  static final ColorFilterGenerator brannan = ColorFilterGenerator(
    name: 'Brannan',
    filters: <List<double>>[
      ColorFilterAddons.contrast(0.2),
      ColorFilterAddons.colorOverlay(140, 10, 185, 0.1),
    ],
  );

  /// Sutro: Burns photo edges, increases highlights and shadows dramatically with a focus on purple and brown colors
  static final ColorFilterGenerator sutro = ColorFilterGenerator(
    name: 'Sutro',
    filters: <List<double>>[
      ColorFilterAddons.brightness(-0.1),
      ColorFilterAddons.saturation(-0.1),
    ],
  );

  /// Toaster: Ages the image by 'burning' the centre and adds a dramatic vignette
  static final ColorFilterGenerator toaster = ColorFilterGenerator(
    name: 'Toaster',
    filters: <List<double>>[
      ColorFilterAddons.sepia(0.1),
      ColorFilterAddons.colorOverlay(255, 145, 0, 0.2),
    ],
  );

  /// Walden: Increases exposure and adds a yellow tint
  static final ColorFilterGenerator walden = ColorFilterGenerator(
    name: 'Walden',
    filters: <List<double>>[
      ColorFilterAddons.brightness(0.1),
      ColorFilterAddons.colorOverlay(255, 255, 0, 0.2),
    ],
  );

  /// 1977: The increased exposure with a red tint gives the photograph a rosy, brighter, faded look.
  static final ColorFilterGenerator f1977 = ColorFilterGenerator(
    name: '1977',
    filters: <List<double>>[
      ColorFilterAddons.colorOverlay(255, 25, 0, 0.15),
      ColorFilterAddons.brightness(0.1),
    ],
  );

  /// Kelvin: Increases saturation and temperature to give it a radiant 'glow'
  static final ColorFilterGenerator kelvin = ColorFilterGenerator(
    name: 'Kelvin',
    filters: <List<double>>[
      ColorFilterAddons.colorOverlay(255, 140, 0, 0.1),
      ColorFilterAddons.rgbScale(1.15, 1.05, 1),
      ColorFilterAddons.saturation(0.35),
    ],
  );

  /// Maven: darkens images, increases shadows, and adds a slightly yellow tint overal
  static final ColorFilterGenerator maven = ColorFilterGenerator(
    name: 'Maven',
    filters: <List<double>>[
      ColorFilterAddons.colorOverlay(225, 240, 0, 0.1),
      ColorFilterAddons.saturation(0.25),
      ColorFilterAddons.contrast(0.05),
    ],
  );

  /// Ginza: brightens and adds a warm glow
  static final ColorFilterGenerator ginza = ColorFilterGenerator(
    name: 'Ginza',
    filters: <List<double>>[
      ColorFilterAddons.sepia(0.06),
      ColorFilterAddons.brightness(0.1),
    ],
  );

  /// Skyline: brightens to the image pop
  static final ColorFilterGenerator skyline = ColorFilterGenerator(
    name: 'Skyline',
    filters: <List<double>>[
      ColorFilterAddons.saturation(0.35),
      ColorFilterAddons.brightness(0.1),
    ],
  );

  /// Dogpatch: increases the contrast, while washing out the lighter colors
  static final ColorFilterGenerator dogpatch = ColorFilterGenerator(
    name: 'Dogpatch',
    filters: <List<double>>[
      ColorFilterAddons.contrast(0.15),
      ColorFilterAddons.brightness(0.1),
    ],
  );

  /// Brooklyn
  static final ColorFilterGenerator brooklyn = ColorFilterGenerator(
    name: 'Brooklyn',
    filters: <List<double>>[
      ColorFilterAddons.colorOverlay(25, 240, 252, 0.05),
      ColorFilterAddons.sepia(0.3),
    ],
  );

  /// Helena: adds an orange and teal vibe
  static final ColorFilterGenerator helena = ColorFilterGenerator(
    name: 'Helena',
    filters: <List<double>>[
      ColorFilterAddons.colorOverlay(208, 208, 86, 0.2),
      ColorFilterAddons.contrast(0.15),
    ],
  );

  /// Ashby: gives images a great golden glow and a subtle vintage feel
  static final ColorFilterGenerator ashby = ColorFilterGenerator(
    name: 'Ashby',
    filters: <List<double>>[
      ColorFilterAddons.colorOverlay(255, 160, 25, 0.1),
      ColorFilterAddons.brightness(0.1),
    ],
  );

  /// Charmes: a high contrast filter, warming up colors in your image with a red tint
  static final ColorFilterGenerator charmes = ColorFilterGenerator(
    name: 'Charmes',
    filters: <List<double>>[
      ColorFilterAddons.colorOverlay(255, 50, 80, 0.12),
      ColorFilterAddons.contrast(0.05),
    ],
  );
}

/// List of filter presets
final List<ColorFilterGenerator> presetFiltersList = [
  PresetFilters.none,
  PresetFilters.aden,
  PresetFilters.amaro,
  PresetFilters.ashby,
  PresetFilters.brannan,
  PresetFilters.brooklyn,
  PresetFilters.charmes,
  PresetFilters.clarendon,
  PresetFilters.crema,
  PresetFilters.dogpatch,
  PresetFilters.earlybird,
  PresetFilters.f1977,
  PresetFilters.gingham,
  PresetFilters.ginza,
  PresetFilters.hefe,
  PresetFilters.helena,
  PresetFilters.hudson,
  PresetFilters.inkwell,
  PresetFilters.juno,
  PresetFilters.kelvin,
  PresetFilters.lark,
  PresetFilters.loFi,
  PresetFilters.ludwig,
  PresetFilters.maven,
  PresetFilters.mayfair,
  PresetFilters.moon,
  PresetFilters.nashville,
  PresetFilters.perpetua,
  PresetFilters.reyes,
  PresetFilters.rise,
  PresetFilters.sierra,
  PresetFilters.skyline,
  PresetFilters.slumber,
  PresetFilters.stinson,
  PresetFilters.sutro,
  PresetFilters.toaster,
  PresetFilters.valencia,
  PresetFilters.vesper,
  PresetFilters.walden,
  PresetFilters.willow,
  PresetFilters.xProII,
];
