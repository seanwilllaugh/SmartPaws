export interface PetState {
  name: string;
  happiness: number; // 0-100
  lastFed: Date | null;
  totalSessionsCompleted: number;
}

export interface TimerState {
  duration: number; // total duration in seconds
  remaining: number; // seconds left
  isRunning: boolean;
  sessionsToday: number;
}

// === New Types for v0.2 === //

export interface Habit {
    id: string;
    name: string;
    completedToday: boolean;
}

export interface PlantState {
    id: string;
    growthStage: number; // 0=seed, 1=sproud, 2=small, 3=full
    growthProgress: number; // 0-100%
}

export interface HabitState {
    habits: Habit[];
    growthPoints: number;
    lastResetDate: string | null; // ISO date string for daily reset
    plant: PlantState | null; // null until first plant is unlocked
}