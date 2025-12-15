"use client";

import { useEffect, useState } from "react";
import { motion, AnimatePresence } from "framer-motion";
import { useGameStore } from "@/stores/useGameStore";

// Set this to true once you have real pet images in /public/images/
const USE_PIXEL_ART = true;

export default function Pet() {
  const pet = useGameStore((state) => state.pet);
  const justFed = useGameStore((state) => state.justFed);
  const clearJustFed = useGameStore((state) => state.clearJustFed);
  const [hydrated, setHydrated] = useState(false);

  useEffect(() => {
    setHydrated(true);
  }, []);

  useEffect(() => {
    if (justFed) {
      const timeout = setTimeout(() => {
        clearJustFed();
      }, 1000);
      return () => clearTimeout(timeout);
    }
  }, [justFed, clearJustFed]);

  function getPetEmoji(): string {
    if (pet.happiness >= 80) return "🐕";
    if (pet.happiness >= 50) return "🐶";
    if (pet.happiness >= 20) return "🐾";
    return "😢";
  }

  function getPetImage(): string {
    if (pet.happiness >= 60) return "/images/pet-happy.png";
    if (pet.happiness >= 30) return "/images/pet-neutral.png";
    return "/images/pet-sad.png";
  }

  if (!hydrated) {
    return (
      <div className="text-center">
        <div className="text-8xl mb-2">🐶</div>
        <div className="text-stone-600 font-semibold">...</div>
      </div>
    );
  }

  return (
    <div className="text-center">
      <motion.div
        className="mb-2"
        animate={
          justFed
            ? {
                scale: [1, 1.3, 1],
                rotate: [0, -10, 10, -10, 0],
              }
            : { scale: 1, rotate: 0 }
        }
        transition={{
          duration: 0.6,
          ease: "easeInOut",
        }}
      >
        {USE_PIXEL_ART ? (
          <img
            src={getPetImage()}
            alt={pet.name}
            className="w-32 h-32 object-contain"
            style={{ imageRendering: "pixelated" }}
          />
        ) : (
          <span className="text-8xl">{getPetEmoji()}</span>
        )}
      </motion.div>

      <AnimatePresence>
        {justFed && (
          <motion.div
            initial={{ opacity: 0, y: 10 }}
            animate={{ opacity: 1, y: 0 }}
            exit={{ opacity: 0 }}
            className="text-green-600 font-bold text-lg"
          >
            +20 Happiness!
          </motion.div>
        )}
      </AnimatePresence>

      <div className="text-amber-900 font-semibold">{pet.name}</div>
      <div className="text-amber-800 text-sm">
        Happiness: {pet.happiness}/100
      </div>
    </div>
  );
}