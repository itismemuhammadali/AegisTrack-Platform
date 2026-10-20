"""
Firebase & Firestore Service Adapter
Connects to Firebase Local Emulator Suite (or Cloud Firestore) when configured.
Falls back seamlessly to in-memory state store for zero-config offline execution.
"""

import os
import logging
from typing import Dict, Any, List, Optional

logger = logging.getLogger("firebase_service")

FIRESTORE_EMULATOR_HOST = os.getenv("FIRESTORE_EMULATOR_HOST")
FIREBASE_AUTH_EMULATOR_HOST = os.getenv("FIREBASE_AUTH_EMULATOR_HOST")
GOOGLE_APPLICATION_CREDENTIALS = os.getenv("GOOGLE_APPLICATION_CREDENTIALS")

_firestore_client = None

def get_firestore_client():
    """
    Initializes and caches the Firestore client if firebase-admin or google-cloud-firestore is available.
    """
    global _firestore_client
    if _firestore_client is not None:
        return _firestore_client

    if FIRESTORE_EMULATOR_HOST or GOOGLE_APPLICATION_CREDENTIALS:
        try:
            import firebase_admin  # type: ignore
            from firebase_admin import firestore  # type: ignore

            if not firebase_admin._apps:
                firebase_admin.initialize_app()
            _firestore_client = firestore.client()
            logger.info("Firestore client initialized successfully (Emulator: %s)", FIRESTORE_EMULATOR_HOST)
            return _firestore_client
        except Exception as e:
            logger.warning("Could not initialize Firestore client: %s. Using local store.", str(e))

    return None

def sync_record_to_firestore(collection: str, doc_id: str, data: Dict[str, Any]) -> bool:
    """
    Synchronizes a record to Firestore if available; returns True if synced, False if local store used.
    """
    client = get_firestore_client()
    if client:
        try:
            client.collection(collection).document(doc_id).set(data, merge=True)
            return True
        except Exception as e:
            logger.error("Failed to write to Firestore collection %s: %s", collection, str(e))
    return False
