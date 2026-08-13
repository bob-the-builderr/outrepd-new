import { TIERS, DIVISION_NAMES } from "@/constants/tiers";
import { W, CANVAS_H, NODE_SPACING } from "@/constants/canvas";

export const ALL_NODES = (() => {
  const nodes = [];
  TIERS.forEach((tier, tierIdx) => {
    DIVISION_NAMES.forEach((divName, divIdx) => {
      const nodeIdx = tierIdx * 4 + divIdx;
      const y = CANVAS_H - 80 - nodeIdx * NODE_SPACING;
      nodes.push({
        nodeIdx,
        tierIdx,
        divIdx,
        divName,
        color: tier.color,
        icon: tier.icon,
        reward: tier.reward,
        isTierEntry: divIdx === 0 && tierIdx > 0,
        xRatio: 0.5,
        y,
        label: `${tier.name} ${divName}`,
        tierName: tier.name,
      });
    });
  });
  return nodes;
})();

export const segPath = (ai, bi) => {
  const a = ALL_NODES[ai],
    b = ALL_NODES[bi];
  const ax = a.xRatio * W,
    ay = a.y;
  const bx = b.xRatio * W,
    by = b.y;
  const midY = (ay + by) / 2;
  return `M ${ax} ${ay} C ${ax} ${midY}, ${bx} ${midY}, ${bx} ${by}`;
};

export const fullRoadPath = () => {
  let d = `M ${ALL_NODES[0].xRatio * W} ${ALL_NODES[0].y}`;
  for (let i = 1; i < ALL_NODES.length; i++) {
    const p = ALL_NODES[i - 1],
      c = ALL_NODES[i];
    const midY = (p.y + c.y) / 2;
    d += ` C ${p.xRatio * W} ${midY}, ${c.xRatio * W} ${midY}, ${c.xRatio * W} ${c.y}`;
  }
  return d;
};
