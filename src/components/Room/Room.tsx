"use client";

import { useEffect } from "react";
import Pet from "./Pet";
import Plant from "./Plant";
import { useGameStore } from "@/stores/useGameStore";

export default function Room() {
  const calculateDecay = useGameStore((state) => state.calculateDecay);
  const checkDailyReset = useGameStore((state) => state.checkDailyReset);

  useEffect(() => {
    calculateDecay();
    checkDailyReset();
  }, [calculateDecay, checkDailyReset]);

  return (
    <div className="relative w-full h-96 rounded-lg overflow-hidden">
      {/* Background Layer */}
      <div
        className="absolute inset-0"
        style={{
          backgroundImage: "url('/images/room.png')",
          backgroundSize: "cover",
          backgroundPosition: "center",
          imageRendering: "pixelated",
        }}
      />

      {/* Plant Layer - positioned in corner */}
      <div className="absolute bottom-12 left-8">
        <Plant />
      </div>

      {/* Pet Layer */}
      <div className="absolute inset-0 flex items-end justify-center pb-12">
        <Pet />
      </div>
    </div>
  );
}