"use client";

import { useState } from "react";
import { motion } from "framer-motion";
import { useGameStore } from "@/stores/useGameStore";
import { Habit } from "@/types";

interface HabitItemProps {
  habit: Habit;
}

export default function HabitItem({ habit }: HabitItemProps) {
  const [showDelete, setShowDelete] = useState(false);
  const toggleHabit = useGameStore((state) => state.toggleHabit);
  const removeHabit = useGameStore((state) => state.removeHabit);

  return (
    <motion.div
      layout
      initial={{ opacity: 0, y: -10 }}
      animate={{ opacity: 1, y: 0 }}
      exit={{ opacity: 0, x: -20 }}
      className="flex items-center gap-3 p-2 bg-stone-600/50 rounded group"
      onMouseEnter={() => setShowDelete(true)}
      onMouseLeave={() => setShowDelete(false)}
    >
      {/* Checkbox */}
      <button
        onClick={() => toggleHabit(habit.id)}
        className={`w-5 h-5 rounded border-2 flex items-center justify-center
                    transition-all duration-200
                    ${
                      habit.completedToday
                        ? "bg-green-500 border-green-500"
                        : "border-stone-400 hover:border-amber-500"
                    }`}
      >
        {habit.completedToday && (
          <motion.svg
            initial={{ scale: 0 }}
            animate={{ scale: 1 }}
            className="w-3 h-3 text-white"
            fill="none"
            viewBox="0 0 24 24"
            stroke="currentColor"
            strokeWidth={3}
          >
            <path
              strokeLinecap="round"
              strokeLinejoin="round"
              d="M5 13l4 4L19 7"
            />
          </motion.svg>
        )}
      </button>

      {/* Habit Name */}
      <span
        className={`flex-1 text-sm transition-all duration-200 ${
          habit.completedToday
            ? "text-stone-400 line-through"
            : "text-white"
        }`}
      >
        {habit.name}
      </span>

      {/* Delete Button */}
      <button
        onClick={() => removeHabit(habit.id)}
        className={`text-stone-500 hover:text-red-400 transition-opacity duration-200
                    ${showDelete ? "opacity-100" : "opacity-0"}`}
        aria-label="Delete habit"
      >
        <svg
          className="w-4 h-4"
          fill="none"
          viewBox="0 0 24 24"
          stroke="currentColor"
          strokeWidth={2}
        >
          <path
            strokeLinecap="round"
            strokeLinejoin="round"
            d="M6 18L18 6M6 6l12 12"
          />
        </svg>
      </button>
    </motion.div>
  );
}