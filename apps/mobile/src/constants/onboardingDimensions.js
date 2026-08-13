import { Dimensions } from "react-native";

export const ITEM_HEIGHT = 60;
export const TICK_WIDTH = 12;
export const HEIGHT_TICK_HEIGHT = 12;
export const SCREEN_WIDTH = Dimensions.get("window").width;
export const SCREEN_HEIGHT = Dimensions.get("window").height;
export const CONTAINER_WIDTH = SCREEN_WIDTH - 48;
export const RULER_PADDING = CONTAINER_WIDTH / 2 - TICK_WIDTH / 2;

export const AGES_LIST = [
  null,
  null,
  null,
  ...Array.from({ length: 88 }, (_, i) => i + 13),
  null,
  null,
  null,
];
