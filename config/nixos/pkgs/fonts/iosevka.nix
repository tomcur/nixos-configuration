{ iosevka }:

iosevka.override {
  set = "code";
  privateBuildPlan = {
    family = "Iosevka";
    spacing = "term";
    design = [
      "no-ligation"
      "sp-force-monospace"
      "v-l-tailed"
      "v-i-hooky"
      "v-zero-dotted"
      "v-at-long"
      "v-numbersign-upright"
    ];
    weights.regular = {
      shape = 400;
      menu = 400;
      css = 400;
    };
    weights.book = {
      shape = 450;
      menu = 450;
      css = 450;
    };
    weights.bold = {
      shape = 700;
      menu = 700;
      css = 700;
    };
    # slants = {
    #   upright = "normal";
    #   italic = "italic";
    # };
  };
}
