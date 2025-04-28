Semaphore:

import java.util.concurrent.Semaphore;

class Shared {
    static Semaphore sem = new Semaphore(1);

    static void printJob(String name) {
        try {
            sem.acquire();
            System.out.println(name + " is printing...");
            Thread.sleep(1000);
            System.out.println(name + " done printing.");
        } catch (Exception e) { }
        finally {
            sem.release();
        }
    }
}

public class SemaphoreExample {
    public static void main(String[] args) {
        Thread t1 = new Thread(() -> Shared.printJob("Thread 1"));
        Thread t2 = new Thread(() -> Shared.printJob("Thread 2"));
        t1.start();
        t2.start();
    }
}

SJF AND FCFS

import java.util.*;

public class CPUScheduling {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);

        System.out.print("Enter number of processes: ");
        int n = sc.nextInt();
        int[] pid = new int[n];
        int[] at = new int[n];
        int[] bt = new int[n];

        for (int i = 0; i < n; i++) {
            pid[i] = i + 1;
            System.out.print("Enter Arrival Time and Burst Time for P" + pid[i] + ": ");
            at[i] = sc.nextInt();
            bt[i] = sc.nextInt();
        }

        System.out.println("\n--- FCFS Scheduling ---");
        fcfs(pid, at, bt, n);

        System.out.println("\n--- SJF Scheduling ---");
        sjf(pid, at, bt, n);

        sc.close();
    }

    static void fcfs(int[] pid, int[] at, int[] bt, int n) {
        int[] ct = new int[n], wt = new int[n], tat = new int[n];
        int time = 0;

        for (int i = 0; i < n; i++) {
            if (time < at[i]) time = at[i];
            time += bt[i];
            ct[i] = time;
            tat[i] = ct[i] - at[i];
            wt[i] = tat[i] - bt[i];
            System.out.println("P" + pid[i] + " CT: " + ct[i] + " TAT: " + tat[i] + " WT: " + wt[i]);
        }
    }

    static void sjf(int[] pid, int[] at, int[] bt, int n) {
        int[] ct = new int[n], wt = new int[n], tat = new int[n];
        boolean[] completed = new boolean[n];
        int time = 0, completedCount = 0;

        while (completedCount < n) {
            int idx = -1, minBT = Integer.MAX_VALUE;
            for (int i = 0; i < n; i++) {
                if (!completed[i] && at[i] <= time && bt[i] < minBT) {
                    minBT = bt[i];
                    idx = i;
                }
            }

            if (idx != -1) {
                time += bt[idx];
                ct[idx] = time;
                tat[idx] = ct[idx] - at[idx];
                wt[idx] = tat[idx] - bt[idx];
                completed[idx] = true;
                completedCount++;
                System.out.println("P" + pid[idx] + " CT: " + ct[idx] + " TAT: " + tat[idx] + " WT: " + wt[idx]);
            } else {
                time++;
            }
        }
    }
}

BEST FIT,WORST FIT,FIRST FIT

import java.util.*;

public class MemoryAllocation {
    public static void main(String[] args) {
        int[] blocks = {100, 500, 200, 300, 600};
        int[] process = {212, 417, 112, 426};

        System.out.println("First Fit:");
        firstFit(blocks.clone(), process);
        System.out.println("\nBest Fit:");
        bestFit(blocks.clone(), process);
    }

    static void firstFit(int[] blocks, int[] process) {
        for (int p : process) {
            boolean allocated = false;
            for (int i = 0; i < blocks.length; i++) {
                if (blocks[i] >= p) {
                    System.out.println("Process " + p + " allocated at block " + i);
                    blocks[i] -= p;
                    allocated = true;
                    break;
                }
            }
            if (!allocated) System.out.println("Process " + p + " not allocated");
        }
    }

    static void bestFit(int[] blocks, int[] process) {
        for (int p : process) {
            int bestIdx = -1;
            for (int i = 0; i < blocks.length; i++) {
                if (blocks[i] >= p) {
                    if (bestIdx == -1 || blocks[i] < blocks[bestIdx])
                        bestIdx = i;
                }
            }
            if (bestIdx != -1) {
                System.out.println("Process " + p + " allocated at block " + bestIdx);
                blocks[bestIdx] -= p;
            } else {
                System.out.println("Process " + p + " not allocated");
            }
        }
    }
}
