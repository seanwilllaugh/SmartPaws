import { create } from "zustand";
import { persist } from "zustand/middleware";
import { PetState, TimerState, HabitState, Habit, PlantState } from "@/types";

// === CONSTANTS ===
const POINTS_PER_HABIT = 10;
const POINTS_TO_UNLOCK_PLANT = 30;  // Complete 3 habits to unlock
const POINTS_PER_GROWTH_STAGE = 50; // 5 habits per growth stage

interface GameState {
  // === EXISTING STATE ===
  pet: PetState;
  timer: TimerState;
  justFed: boolean;
  
  // === NEW: HABIT STATE ===
  habits: HabitState;

  // === EXISTING ACTIONS ===
  feedPet: () => void;
  clearJustFed: () => void;
  startTimer: () => void;
  pauseTimer: () => void;
  resetTimer: () => void;
  tick: () => void;
  calculateDecay: () => void;

  // === NEW: HABIT ACTIONS ===
  addHabit: (name: string) => void;
  removeHabit: (id: string) => void;
  toggleHabit: (id: string) => void;
  checkDailyReset: () => void;
}

// Helper to generate unique IDs
const generateId = () => Math.random().toString(36).substring(2, 9);

// Helper to get today's date as string (for comparison)
const getTodayString = () => new Date().toISOString().split("T")[0];

export const useGameStore = create<GameState>()(
  persist(
    (set, get) => ({
      // === EXISTING PET STATE ===
      pet: {
        name: "Buddy",
        happiness: 50,
        lastFed: null,
        totalSessionsCompleted: 0,
      },

      // === EXISTING TIMER STATE ===
      timer: {
        duration: 25 * 60,
        remaining: 25 * 60,
        isRunning: false,
        sessionsToday: 0,
      },

      justFed: false,

      // === NEW: INITIAL HABIT STATE ===
      habits: {
        habits: [],
        growthPoints: 0,
        lastResetDate: null,
        plant: null,
      },

      // === EXISTING ACTIONS (unchanged) ===
      feedPet: () =>
        set((state) => ({
          pet: {
            ...state.pet,
            happiness: Math.min(100, state.pet.happiness + 20),
            lastFed: new Date(),
            totalSessionsCompleted: state.pet.totalSessionsCompleted + 1,
          },
          timer: {
            ...state.timer,
            sessionsToday: state.timer.sessionsToday + 1,
          },
          justFed: true,
        })),

      clearJustFed: () => set({ justFed: false }),

      startTimer: () =>
        set((state) => ({
          timer: { ...state.timer, isRunning: true },
        })),

      pauseTimer: () =>
        set((state) => ({
          timer: { ...state.timer, isRunning: false },
        })),

      resetTimer: () =>
        set((state) => ({
          timer: {
            ...state.timer,
            isRunning: false,
            remaining: state.timer.duration,
          },
        })),

      tick: () =>
        set((state) => ({
          timer: {
            ...state.timer,
            remaining: Math.max(0, state.timer.remaining - 1),
          },
        })),

      calculateDecay: () =>
        set((state) => {
          if (!state.pet.lastFed) return state;

          const now = new Date();
          const lastFed = new Date(state.pet.lastFed);
          const hoursSinceLastFed =
            (now.getTime() - lastFed.getTime()) / (1000 * 60 * 60);

          const decayPerHour = 2;
          const decay = Math.floor(hoursSinceLastFed * decayPerHour);
          const newHappiness = Math.max(10, state.pet.happiness - decay);

          if (newHappiness === state.pet.happiness) return state;

          return {
            pet: {
              ...state.pet,
              happiness: newHappiness,
              lastFed: now,
            },
          };
        }),

      // === NEW: HABIT ACTIONS ===
      
      addHabit: (name: string) =>
        set((state) => ({
          habits: {
            ...state.habits,
            habits: [
              ...state.habits.habits,
              {
                id: generateId(),
                name: name.trim(),
                completedToday: false,
              },
            ],
          },
        })),

      removeHabit: (id: string) =>
        set((state) => ({
          habits: {
            ...state.habits,
            habits: state.habits.habits.filter((h) => h.id !== id),
          },
        })),

      toggleHabit: (id: string) =>
        set((state) => {
          const habit = state.habits.habits.find((h) => h.id === id);
          if (!habit) return state;

          const wasCompleted = habit.completedToday;
          const pointsDelta = wasCompleted ? -POINTS_PER_HABIT : POINTS_PER_HABIT;
          const newGrowthPoints = Math.max(0, state.habits.growthPoints + pointsDelta);

          // Update the habit completion status
          const updatedHabits = state.habits.habits.map((h) =>
            h.id === id ? { ...h, completedToday: !h.completedToday } : h
          );

          // Calculate plant state
          let newPlant = state.habits.plant;

          // Unlock plant if we hit the threshold and don't have one yet
          if (!newPlant && newGrowthPoints >= POINTS_TO_UNLOCK_PLANT) {
            newPlant = {
              id: generateId(),
              growthStage: 0,
              growthProgress: 0,
            };
          }

          // Update plant growth if we have a plant
          if (newPlant) {
            // Calculate total progress points (after unlock threshold)
            const progressPoints = Math.max(0, newGrowthPoints - POINTS_TO_UNLOCK_PLANT);
            
            // Each stage requires POINTS_PER_GROWTH_STAGE
            const totalStages = Math.floor(progressPoints / POINTS_PER_GROWTH_STAGE);
            const newStage = Math.min(3, totalStages); // Cap at stage 3 (full)
            
            // Progress toward next stage (0-100%)
            const pointsInCurrentStage = progressPoints % POINTS_PER_GROWTH_STAGE;
            const newProgress = newStage >= 3 
              ? 100 // Full plant, max progress
              : Math.floor((pointsInCurrentStage / POINTS_PER_GROWTH_STAGE) * 100);

            newPlant = {
              ...newPlant,
              growthStage: newStage,
              growthProgress: newProgress,
            };
          }

          return {
            habits: {
              ...state.habits,
              habits: updatedHabits,
              growthPoints: newGrowthPoints,
              plant: newPlant,
            },
          };
        }),

      checkDailyReset: () => {
        const today = getTodayString();
        const state = get();

        // If it's a new day, reset habit completions
        if (state.habits.lastResetDate !== today) {
          set({
            habits: {
              ...state.habits,
              habits: state.habits.habits.map((h) => ({
                ...h,
                completedToday: false,
              })),
              lastResetDate: today,
            },
            timer: {
              ...state.timer,
              sessionsToday: 0,
            },
          });
        }
      },
    }),
    {
      name: "smartpaws-storage",
      partialize: (state) => ({
        pet: state.pet,
        timer: {
          ...state.timer,
          isRunning: false,
        },
        habits: state.habits, // Persist habits!
      }),
    }
  )
);