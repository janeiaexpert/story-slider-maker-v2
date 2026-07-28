const KEY = "carousel-space-id-v1";

function randomId() {
  // 32 chars base36 — unguessable enough to act as access secret
  const a = Math.random().toString(36).slice(2);
  const b = Math.random().toString(36).slice(2);
  const c = Date.now().toString(36);
  return (a + b + c).slice(0, 32);
}

export function getSpaceId(): string {
  if (typeof window === "undefined") return "";
  // Allow joining a space via URL param ?space=XXX
  try {
    const url = new URL(window.location.href);
    const fromUrl = url.searchParams.get("space");
    if (fromUrl && fromUrl.length >= 8) {
      localStorage.setItem(KEY, fromUrl);
      // Clean URL so the secret isn't kept in the bar
      url.searchParams.delete("space");
      window.history.replaceState({}, "", url.toString());
      return fromUrl;
    }
  } catch {}
  let id = localStorage.getItem(KEY);
  if (!id) {
    id = randomId();
    localStorage.setItem(KEY, id);
  }
  return id;
}

export function setSpaceId(id: string) {
  localStorage.setItem(KEY, id);
}

export function shareUrl(spaceId: string) {
  if (typeof window === "undefined") return "";
  const u = new URL(window.location.origin);
  u.searchParams.set("space", spaceId);
  return u.toString();
}

export function qrUrl(text: string, size = 220) {
  return `https://api.qrserver.com/v1/create-qr-code/?size=${size}x${size}&data=${encodeURIComponent(
    text,
  )}`;
}
