"use client";

import { motion } from "framer-motion";
import { useGameStore } from "@/stores/useGameStore";
import Image from "next/image";

// Placeholder colors for each growth stage (replace with actual sprites later)
const STAGE_STYLES = [
  { bg: "bg-amber-900", size: "w-4 h-4" },      // 0: Seed
  { bg: "bg-green-700", size: "w-6 h-8" },      // 1: Sprout
  { bg: "bg-green-600", size: "w-10 h-16" },    // 2: Small
  { bg: "bg-green-500", size: "w-14 h-24" },    // 3: Full
];

export default function Plant() {
  const plant = useGameStore((state) => state.habits.plant);

  if (!plant) return null;

  const style = STAGE_STYLES[plant.growthStage];

  // TODO: Replace with actual sprite images
  // <Image 
  //   src={`/images/plants/plant-stage-${plant.growthStage}.png`}
  //   alt={`Plant stage ${plant.growthStage}`}
  //   width={56}
  //   height={96}
  //   style={{ imageRendering: "pixelated" }}
  // />

  return (
    <motion.div
      initial={{ scale: 0, opacity: 0 }}
      animate={{ scale: 1, opacity: 1 }}
      transition={{ 
        type: "spring", 
        stiffness: 200, 
        damping: 15 
      }}
      className={`${style.bg} ${style.size} rounded-sm`}
      style={{ imageRendering: "pixelated" }}
    />
  );
}