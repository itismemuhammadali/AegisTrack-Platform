/**
 * Firebase Client & Firestore Database Configuration
 * Connects to Firebase Local Emulator Suite (Firestore: 8080, Auth: 9099)
 * or production Cloud Firebase when config variables are provided.
 */

import { initializeApp, getApps, getApp } from "firebase/app";
import {
  getFirestore,
  connectFirestoreEmulator,
  collection,
  doc,
  getDocs,
  getDoc,
  setDoc,
  addDoc,
  updateDoc,
  deleteDoc,
  query,
  where,
  orderBy,
  limit,
  type Firestore,
} from "firebase/firestore";
import { getAuth, connectAuthEmulator, type Auth } from "firebase/auth";

const firebaseConfig = {
  apiKey: process.env.NEXT_PUBLIC_FIREBASE_API_KEY || "demo-api-key-joshua-hughes",
  authDomain: process.env.NEXT_PUBLIC_FIREBASE_AUTH_DOMAIN || "joshua-hughes-legal.firebaseapp.com",
  projectId: process.env.NEXT_PUBLIC_FIREBASE_PROJECT_ID || "joshua-hughes-legal",
  storageBucket: process.env.NEXT_PUBLIC_FIREBASE_STORAGE_BUCKET || "joshua-hughes-legal.appspot.com",
  messagingSenderId: process.env.NEXT_PUBLIC_FIREBASE_MESSAGING_SENDER_ID || "100000000000",
  appId: process.env.NEXT_PUBLIC_FIREBASE_APP_ID || "1:100000000000:web:abcdef123456",
};

// Singleton App Instance
const app = getApps().length === 0 ? initializeApp(firebaseConfig) : getApp();

export const db: Firestore = getFirestore(app);
export const auth: Auth = getAuth(app);

// Connect to Local Firebase Emulators in development / local workspace
let emulatorsConnected = false;

export function initFirebaseEmulators() {
  if (emulatorsConnected) return;

  const isServer = typeof window === "undefined";
  const useEmulator =
    process.env.NEXT_PUBLIC_USE_FIREBASE_EMULATOR !== "false" ||
    isServer ||
    (typeof window !== "undefined" && (window.location.hostname === "localhost" || window.location.hostname === "127.0.0.1"));

  if (useEmulator) {
    try {
      const firestoreHost = process.env.NEXT_PUBLIC_FIRESTORE_EMULATOR_HOST || "127.0.0.1";
      const firestorePort = Number(process.env.NEXT_PUBLIC_FIRESTORE_EMULATOR_PORT || 8080);
      connectFirestoreEmulator(db, firestoreHost, firestorePort);

      const authHost = process.env.NEXT_PUBLIC_FIREBASE_AUTH_EMULATOR_HOST || "http://127.0.0.1:9099";
      connectAuthEmulator(auth, authHost, { disableWarnings: true });

      emulatorsConnected = true;
    } catch {
      // Ignored if already connected
    }
  }
}

// Auto-initialize on import
initFirebaseEmulators();

// Re-export common Firestore operations for convenience across services
export {
  collection,
  doc,
  getDocs,
  getDoc,
  setDoc,
  addDoc,
  updateDoc,
  deleteDoc,
  query,
  where,
  orderBy,
  limit,
};
