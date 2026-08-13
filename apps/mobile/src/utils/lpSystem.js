export const getLPChange = (result, opponentTierIdx, myTierIdx) => {
  if (result === "forfeit") return -25;
  if (result === "win") {
    if (opponentTierIdx > myTierIdx) return 20;
    if (opponentTierIdx === myTierIdx) return 15;
    return 10;
  }
  if (opponentTierIdx > myTierIdx) return -10;
  if (opponentTierIdx === myTierIdx) return -15;
  return -20;
};

export const applyLPChange = (state, lpChange) => {
  const { tierIdx, divIdx, lp, demotionShield } = state;
  const isLegendI = tierIdx === 8 && divIdx === 3;
  if (isLegendI) {
    return {
      tierIdx: 8,
      divIdx: 3,
      lp: Math.max(0, lp + lpChange),
      demotionShield,
      promoted: false,
      demoted: false,
    };
  }
  let newLp = lp + lpChange;
  let newTierIdx = tierIdx;
  let newDivIdx = divIdx;
  let newShield = demotionShield;
  let promoted = false;
  let demoted = false;

  if (newLp >= 100) {
    newLp -= 100;
    promoted = true;
    if (divIdx === 3) {
      newTierIdx = tierIdx + 1;
      newDivIdx = 0;
    } else {
      newDivIdx = divIdx + 1;
    }
    newShield = true;
  } else if (newLp < 0) {
    if (demotionShield) {
      newLp = 0;
      newShield = false;
    } else {
      demoted = true;
      if (tierIdx === 0 && divIdx === 0) {
        newLp = 0;
      } else {
        if (divIdx === 0) {
          newTierIdx = tierIdx - 1;
          newDivIdx = 3;
        } else {
          newDivIdx = divIdx - 1;
        }
        newLp = 75;
        newShield = true;
      }
    }
  }
  if (newLp < 0) newLp = 0;
  return {
    tierIdx: newTierIdx,
    divIdx: newDivIdx,
    lp: newLp,
    demotionShield: newShield,
    promoted,
    demoted,
  };
};
