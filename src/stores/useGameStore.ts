import { create } from "zustand";
import { persist } from "zustand/middleware";
import { PetState, TimerState } from "@/types";

interface GameState {
  pet: PetState;
  timer: TimerState;
  justFed: boolean;
  feedPet: () => void;
  clearJustFed: () => void;
  startTimer: () => void;
  pauseTimer: () => void;
  resetTimer: () => void;
  tick: () => void;
  calculateDecay: () => void;
}

export const useGameStore = create<GameState>()(
  persist(
    (set) => ({
      pet: {
        name: "Buddy",
        happiness: 50,
        lastFed: null,
        totalSessionsCompleted: 0,
      },

      timer: {
        duration: 25 * 60,
        remaining: 25 * 60,
        isRunning: false,
        sessionsToday: 0,
      },

      justFed: false,

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
    }),
    {
      name: "smartpaws-storage",
      partialize: (state) => ({
        pet: state.pet,
        timer: {
          ...state.timer,
          isRunning: false, // Don't persist running state
        },
      }),
    }
  )
);