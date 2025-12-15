"use client";

import { useEffect } from "react";
import { useGameStore } from "@/stores/useGameStore";

export default function Timer() {
  const timer = useGameStore((state) => state.timer);
  const { startTimer, pauseTimer, resetTimer, tick, feedPet } = useGameStore();

  // Format seconds into MM:SS
  function formatTime(seconds: number): string {
    const mins = Math.floor(seconds / 60);
    const secs = seconds % 60;
    return `${mins.toString().padStart(2, "0")}:${secs.toString().padStart(2, "0")}`;
  }

  // Countdown logic
  useEffect(() => {
    if (!timer.isRunning || timer.remaining <= 0) return;

    const interval = setInterval(() => {
      tick();
    }, 1000);

    return () => clearInterval(interval);
  }, [timer.isRunning, timer.remaining, tick]);

  // Handle timer completion
  useEffect(() => {
    if (timer.remaining === 0 && timer.isRunning) {
      pauseTimer();
      feedPet();
    }
  }, [timer.remaining, timer.isRunning, pauseTimer, feedPet]);

  return (
    <div className="bg-stone-700 rounded-lg p-6 text-center">
      <div className="text-6xl font-mono text-white mb-6">
        {formatTime(timer.remaining)}
      </div>
      <div className="flex gap-4 justify-center">
        {!timer.isRunning ? (
          <button
            onClick={startTimer}
            className="bg-green-600 hover:bg-green-500 text-white px-6 py-2 rounded-lg font-semibold"
          >
            Start
          </button>
        ) : (
          <button
            onClick={pauseTimer}
            className="bg-yellow-600 hover:bg-yellow-500 text-white px-6 py-2 rounded-lg font-semibold"
          >
            Pause
          </button>
        )}
        <button
          onClick={resetTimer}
          className="bg-stone-600 hover:bg-stone-500 text-white px-6 py-2 rounded-lg font-semibold"
        >
          Reset
        </button>
      </div>
    </div>
  );
}