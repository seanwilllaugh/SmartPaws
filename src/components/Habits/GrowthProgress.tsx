"use client";

import { motion } from "framer-motion";
import { useGameStore } from "@/stores/useGameStore";

const POINTS_TO_UNLOCK_PLANT = 30;
const POINTS_PER_GROWTH_STAGE = 50;

const STAGE_NAMES = ["Seed", "Sprout", "Small", "Full Bloom"];

export default function GrowthProgress() {
  const plant = useGameStore((state) => state.habits.plant);
  const growthPoints = useGameStore((state) => state.habits.growthPoints);

  // Before plant is unlocked
  if (!plant) {
    const progress = Math.min(100, (growthPoints / POINTS_TO_UNLOCK_PLANT) * 100);
    
    return (
      <div className="mb-4">
        <div className="flex justify-between text-xs text-stone-400 mb-1">
          <span>🌱 Unlock your first plant</span>
          <span>{growthPoints}/{POINTS_TO_UNLOCK_PLANT} pts</span>
        </div>
        <div className="h-2 bg-stone-600 rounded-full overflow-hidden">
          <motion.div
            className="h-full bg-gradient-to-r from-green-600 to-green-400"
            initial={{ width: 0 }}
            animate={{ width: `${progress}%` }}
            transition={{ duration: 0.3 }}
          />
        </div>
      </div>
    );
  }

  // After plant is unlocked
  const stageName = STAGE_NAMES[plant.growthStage];
  const nextStageName = STAGE_NAMES[Math.min(3, plant.growthStage + 1)];
  const isFullyGrown = plant.growthStage >= 3;

  return (
    <div className="mb-4">
      <div className="flex justify-between text-xs text-stone-400 mb-1">
        <span>
          🌿 {stageName}
          {!isFullyGrown && ` → ${nextStageName}`}
        </span>
        <span>
          {isFullyGrown ? "Fully grown! 🎉" : `${plant.growthProgress}%`}
        </span>
      </div>
      <div className="h-2 bg-stone-600 rounded-full overflow-hidden">
        <motion.div
          className={`h-full ${
            isFullyGrown
              ? "bg-gradient-to-r from-amber-500 to-yellow-400"
              : "bg-gradient-to-r from-green-600 to-green-400"
          }`}
          initial={{ width: 0 }}
          animate={{ width: `${plant.growthProgress}%` }}
          transition={{ duration: 0.3 }}
        />
      </div>
    </div>
  );
}