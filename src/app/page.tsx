import Room from "@/components/Room/Room";
import Timer from "@/components/Timer/Timer";

export default function Home() {
  return (
    <main className="min-h-screen bg-stone-800 p-8">
      <h1 className="text-2xl font-bold text-white mb-4">SmartPaws</h1>
      <div className="max-w-2xl mx-auto space-y-6">
        <Room />
        <Timer />
      </div>
    </main>
  );
}