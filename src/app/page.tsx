import Room from "@/components/Room/Room";
import Timer from "@/components/Timer/Timer";
import HabitPanel from "@/components/Habits/HabitPanel";

export default function Home() {
  return (
    <main className="min-h-screen bg-stone-800 p-8">
      <h1 className="text-2xl font-bold text-white mb-4">SmartPaws</h1>
      <div className="max-w-2xl mx-auto space-y-6">
        <Room />
        <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
          <Timer />
          <HabitPanel />
        </div>
      </div>
    </main>
  );
}