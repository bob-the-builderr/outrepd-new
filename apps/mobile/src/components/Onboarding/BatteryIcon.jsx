import React from "react";
import Svg, { Rect } from "react-native-svg";

export const BatteryIcon = ({ level }) => {
  return (
    <Svg width={40} height={20} viewBox="0 0 40 20">
      <Rect
        x={1}
        y={1}
        width={34}
        height={18}
        rx={4}
        stroke="#444444"
        strokeWidth={1.5}
        fill="none"
      />
      <Rect x={36} y={6} width={3} height={8} rx={1.5} fill="#444444" />
      {level >= 1 && (
        <Rect x={4} y={4} width={6} height={12} rx={1} fill="#4CD964" />
      )}
      {level >= 2 && (
        <Rect x={12} y={4} width={6} height={12} rx={1} fill="#4CD964" />
      )}
      {level >= 3 && (
        <Rect x={20} y={4} width={6} height={12} rx={1} fill="#4CD964" />
      )}
      {level >= 4 && (
        <Rect x={28} y={4} width={6} height={12} rx={1} fill="#4CD964" />
      )}
    </Svg>
  );
};
