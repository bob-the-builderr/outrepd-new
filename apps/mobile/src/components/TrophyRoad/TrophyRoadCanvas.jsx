import React, { useState } from "react";
import { View, Text, StyleSheet, Pressable } from "react-native";
import { Image } from "expo-image";
import Svg, {
  Line,
  Rect,
  Defs,
  LinearGradient as SvgLinearGradient,
  Stop,
} from "react-native-svg";
import { W, CANVAS_H, NODE_SPACING } from "@/constants/canvas";
import { ALL_NODES } from "@/utils/roadNodes";
import { TIERS, NEEDS_WHITE_TEXT } from "@/constants/tiers";

const RULER_X = 18;

export const TrophyRoadCanvas = ({
  currentNodeIdx,
  currentTier,
  playerLp = 0,
}) => {
  const [lpLabelVisible, setLpLabelVisible] = useState(false);

  const totalNodes = ALL_NODES.length;
  const currentNode = ALL_NODES[currentNodeIdx];

  // Y position of the partial fill inside the current segment (fills upward)
  const partialFillY =
    currentNodeIdx < totalNodes - 1
      ? currentNode.y - (playerLp / 100) * NODE_SPACING
      : currentNode.y;

  return (
    <View style={{ width: W, height: CANVAS_H, backgroundColor: "#04030A" }}>
      {/* ── RULER + CONNECTORS SVG ── */}
      <Svg
        width={W}
        height={CANVAS_H}
        style={StyleSheet.absoluteFill}
        pointerEvents="none"
      >
        <Defs>
          <SvgLinearGradient id="topDim" x1="0" y1="0" x2="0" y2="1">
            <Stop offset="0" stopColor="#04030A" stopOpacity="1" />
            <Stop offset="0.12" stopColor="#04030A" stopOpacity="0" />
          </SvgLinearGradient>
        </Defs>

        {/* ── Ruler background (dim grey vertical line) ── */}
        <Line
          x1={RULER_X}
          y1={ALL_NODES[totalNodes - 1].y}
          x2={RULER_X}
          y2={ALL_NODES[0].y}
          stroke="#1C1C2E"
          strokeWidth={3}
          strokeLinecap="round"
        />

        {/* ── Completed segments — colored per tier ── */}
        {ALL_NODES.slice(0, currentNodeIdx).map((node, i) => {
          if (i >= totalNodes - 1) return null;
          const tier = TIERS[node.tierIdx];
          const next = ALL_NODES[i + 1];
          return (
            <Line
              key={`ruler-fill-${i}`}
              x1={RULER_X}
              y1={node.y}
              x2={RULER_X}
              y2={next.y}
              stroke={tier.color}
              strokeWidth={3}
              strokeLinecap="round"
            />
          );
        })}

        {/* ── Current partial segment fill ── */}
        {currentNodeIdx < totalNodes - 1 && playerLp > 0 && (
          <Line
            x1={RULER_X}
            y1={currentNode.y}
            x2={RULER_X}
            y2={partialFillY}
            stroke={TIERS[currentNode.tierIdx].color}
            strokeWidth={3}
            strokeLinecap="round"
          />
        )}

        {/* ── Tick marks + horizontal connectors ── */}
        {ALL_NODES.map((node, i) => {
          const isCompleted = i < currentNodeIdx;
          const isCurrent = i === currentNodeIdx;
          const tier = TIERS[node.tierIdx];
          const baseSize = node.isTierEntry ? 72 : 60;
          const size = isCurrent ? 140 : baseSize;
          const badgeLeft = W / 2 - size / 2;

          const tickColor = isCompleted
            ? tier.color
            : isCurrent
              ? tier.color
              : "#2A2A3A";

          const connectorColor = isCompleted
            ? tier.color + "55"
            : isCurrent
              ? tier.color + "44"
              : "#1A1A28";

          return (
            <React.Fragment key={`connector-${i}`}>
              {/* Tick mark on ruler */}
              <Line
                x1={RULER_X - 5}
                y1={node.y}
                x2={RULER_X + 8}
                y2={node.y}
                stroke={tickColor}
                strokeWidth={isCurrent ? 2.5 : 1.5}
                strokeLinecap="round"
              />
              {/* Horizontal connector to badge */}
              <Line
                x1={RULER_X + 8}
                y1={node.y}
                x2={badgeLeft - 6}
                y2={node.y}
                stroke={connectorColor}
                strokeWidth={0.75}
                strokeDasharray={isCurrent ? "0" : "5,5"}
                strokeLinecap="round"
              />
            </React.Fragment>
          );
        })}

        {/* Top vignette */}
        <Rect x={0} y={0} width={W} height={180} fill="url(#topDim)" />
      </Svg>

      {/* ── FULL-HEIGHT RULER TOUCH STRIP ── */}
      <Pressable
        onPressIn={() => setLpLabelVisible(true)}
        onPressOut={() => setLpLabelVisible(false)}
        style={{
          position: "absolute",
          left: 0,
          top: 0,
          width: 52,
          height: CANVAS_H,
          zIndex: 11,
        }}
      />

      {/* ── CURRENT LP INDICATOR NEEDLE ── */}
      {currentNodeIdx < totalNodes - 1 && (
        <View
          style={{
            position: "absolute",
            left: RULER_X - 18,
            top: partialFillY - 5,
            flexDirection: "row",
            alignItems: "center",
            zIndex: 10,
            pointerEvents: "none",
          }}
        >
          <View
            style={{
              width: 10,
              height: 10,
              borderRadius: 5,
              backgroundColor: TIERS[currentNode.tierIdx].color,
              marginLeft: 13,
              shadowColor: TIERS[currentNode.tierIdx].color,
              shadowOffset: { width: 0, height: 0 },
              shadowOpacity: 1,
              shadowRadius: 8,
              elevation: 4,
            }}
          />
          {lpLabelVisible && (
            <View
              style={{
                backgroundColor: TIERS[currentNode.tierIdx].color + "EE",
                paddingHorizontal: 8,
                paddingVertical: 4,
                borderRadius: 4,
                marginLeft: 12,
              }}
            >
              <Text
                style={{
                  color: NEEDS_WHITE_TEXT.includes(
                    TIERS[currentNode.tierIdx].color,
                  )
                    ? "#FFF"
                    : "#000",
                  fontSize: 10,
                  fontWeight: "900",
                }}
              >
                {(currentNodeIdx * 100 + playerLp).toLocaleString()} LP
              </Text>
            </View>
          )}
        </View>
      )}

      {/* ── LP LABELS (left of badges, right of ruler) ── */}
      {ALL_NODES.map((node, i) => {
        const isCompleted = i < currentNodeIdx;
        const isCurrent = i === currentNodeIdx;
        const tier = TIERS[node.tierIdx];
        const requiredLp = i * 100;

        return (
          <View
            key={`lp-${i}`}
            style={{
              position: "absolute",
              left: RULER_X + 12,
              top: node.y - 20,
              width: 72,
            }}
          >
            <Text
              style={{
                color: isCompleted
                  ? tier.color + "BB"
                  : isCurrent
                    ? "#FFFFFF"
                    : "#252535",
                fontSize: isCurrent ? 10 : 8,
                fontWeight: isCurrent ? "800" : "500",
              }}
            >
              {requiredLp.toLocaleString()} LP
            </Text>
          </View>
        );
      })}

      {/* ── BADGES (centered) ── */}
      {ALL_NODES.map((node, i) => {
        const isCompleted = i < currentNodeIdx;
        const isCurrent = i === currentNodeIdx;
        const isLocked = i > currentNodeIdx;
        const tier = TIERS[node.tierIdx];

        const baseSize = node.isTierEntry ? 150 : 150;
        const size = isCurrent ? 300 : baseSize;
        const half = size / 2;
        const labelW = 180;

        return (
          <View
            key={`node${i}`}
            style={{
              position: "absolute",
              left: W / 2 - half,
              top: node.y - half,
              alignItems: "center",
            }}
          >
            {/* Badge image */}
            <View
              style={{
                width: size,
                height: size,
                opacity: isLocked ? 0.3 : 1,
              }}
            >
              <Image
                source={{ uri: tier.img }}
                style={{ width: size, height: size }}
                contentFit="contain"
                cachePolicy="memory-disk"
              />
            </View>

            {/* NEW TIER chip */}
            {node.isTierEntry && (isCompleted || isCurrent) && (
              <View
                style={{
                  position: "absolute",
                  top: -14,
                  alignSelf: "center",
                  backgroundColor: tier.color,
                  borderRadius: 6,
                  paddingHorizontal: 7,
                  paddingVertical: 2,
                }}
              >
                <Text
                  style={{
                    color: NEEDS_WHITE_TEXT.includes(tier.color)
                      ? "#FFF"
                      : "#000",
                    fontSize: 8,
                    fontWeight: "900",
                    letterSpacing: 1.5,
                  }}
                >
                  NEW TIER
                </Text>
              </View>
            )}

            {/* Lock icon */}
            {isLocked && (
              <View
                style={{
                  position: "absolute",
                  bottom: -2,
                  right: -2,
                  width: 18,
                  height: 18,
                  borderRadius: 9,
                  backgroundColor: "#080810",
                  borderWidth: 1,
                  borderColor: "#1A1A2A",
                  justifyContent: "center",
                  alignItems: "center",
                }}
              >
                <Text style={{ fontSize: 10 }}>🔒</Text>
              </View>
            )}

            {/* Label below badge */}
            <View
              style={{
                position: "absolute",
                top: size + 6,
                left: -(labelW - size) / 2,
                width: labelW,
                alignItems: "center",
              }}
            >
              <Text
                style={{
                  color: isCurrent
                    ? "#FFFFFF"
                    : isCompleted
                      ? tier.color + "EE"
                      : tier.color + "44",
                  fontWeight: isCurrent
                    ? "900"
                    : node.isTierEntry
                      ? "800"
                      : "600",
                  fontSize: isCurrent ? 13 : node.isTierEntry ? 12 : 10,
                  textAlign: "center",
                  textShadowColor: isCurrent ? tier.color : "transparent",
                  textShadowOffset: { width: 0, height: 0 },
                  textShadowRadius: 10,
                }}
              >
                {node.label}
              </Text>
              {isCurrent && (
                <Text
                  style={{
                    color: "#888888",
                    fontSize: 10,
                    fontWeight: "600",
                    marginTop: 2,
                  }}
                >
                  {(currentNodeIdx * 100 + playerLp).toLocaleString()} Total LP
                </Text>
              )}
            </View>
          </View>
        );
      })}
    </View>
  );
};
