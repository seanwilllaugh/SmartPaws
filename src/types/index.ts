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