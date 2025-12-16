"use client";

import { useState } from "react";
import { useGameStore } from "@/stores/useGameStore";
import HabitItem from "./HabitItem";
import GrowthProgress from "./GrowthProgress";

export default function HabitPanel() {
  const [newHabitName, setNewHabitName] = useState("");
  const habits = useGameStore((state) => state.habits.habits);
  const addHabit = useGameStore((state) => state.addHabit);

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    if (newHabitName.trim()) {
      addHabit(newHabitName);
      setNewHabitName("");
    }
  };

  return (
    <div className="bg-stone-700 rounded-lg p-4">
      <h2 className="text-lg font-semibold text-white mb-3">Daily Habits</h2>

      {/* Growth Progress Bar */}
      <GrowthProgress />

      {/* Habit List */}
      <div className="space-y-2 mb-4">
        {habits.length === 0 ? (
          <p className="text-stone-400 text-sm italic">
            No habits yet. Add one below!
          </p>
        ) : (
          habits.map((habit) => (
            <HabitItem key={habit.id} habit={habit} />
          ))
        )}
      </div>

      {/* Add Habit Form */}
      <form onSubmit={handleSubmit} className="flex gap-2">
        <input
          type="text"
          value={newHabitName}
          onChange={(e) => setNewHabitName(e.target.value)}
          placeholder="Add a habit..."
          className="flex-1 px-3 py-2 bg-stone-600 text-white rounded 
                     placeholder-stone-400 text-sm
                     focus:outline-none focus:ring-2 focus:ring-amber-500"
          maxLength={30}
        />
        <button
          type="submit"
          disabled={!newHabitName.trim()}
          className="px-4 py-2 bg-amber-600 text-white rounded font-medium
                     hover:bg-amber-500 disabled:opacity-50 disabled:cursor-not-allowed
                     transition-colors text-sm"
        >
          Add
        </button>
      </form>
    </div>
  );
}