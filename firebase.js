// Firebase - Budget Dost - Testing + Real dono me yahi chalega
import { initializeApp } from 'firebase/app';
import { getFirestore } from 'firebase/firestore';
import { getAuth } from 'firebase/auth';

const firebaseConfig = {
  apiKey: "AIzaSyAwQfWx3XZMyAz_CS0vA6_G8rmtkX1G_uw,
  authDomain: "budgetdost-1f63c.firebaseapp.com",
  projectId: "budgetdost-1f63c",
  storageBucket: "budgetdost-1f63c.firebasestorage.app",
  messagingSenderId: "879013128524",
  appId: "1:879013128524:android:381d396f48abb95f4d87e9"
};

const app = initializeApp(firebaseConfig);
export const db = getFirestore(app);
export const auth = getAuth(app);
export default app;
