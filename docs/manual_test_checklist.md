# FUVEKON Mobile — Manual test checklist (customer UI)

Use after pulling the customer UI implementation branch. Test on a **regular user** account unless noted.

## Navigation & auth

- [ ] Login as regular user → lands on `/account` (not `/admin`)
- [ ] 5 bottom tabs: Trang chủ / Lịch trình / Vé của tôi / Thông báo / Tài khoản
- [ ] Tab switch preserves state (indexed stack)
- [ ] Detail screens hide bottom nav; back returns to correct tab

## Trang chủ (Màn 12)

- [ ] Hero, bento cards (Vé của tôi, Lịch hôm nay), buy-ticket banner render
- [ ] Shortcuts: Lịch trình, Vé, Artbook, Lost & Found navigate correctly
- [ ] “Mua vé” opens `/ticket/purchase`; back restores home tab
- [ ] Featured event card visible

## Lịch trình (API + hybrid mock)

- [ ] Schedule list loads from `GET /schedules` at `/account/schedule` (backend running)
- [ ] Activity detail opens full-screen from list (timeline from schedule detail)
- [ ] Bookmark → conflict dialog (Màn 19) when overlapping (local itinerary store)
- [ ] Personal itinerary at `/account/schedule/my`
- [ ] Event detail loads from `GET /schedules/:id`
- [ ] Venue map/detail still use mock delegate until public venue API

## Vé (KietPham dark card style)

- [ ] Explore `/ticket`, detail, purchase, my ticket, e-ticket use consistent dark tier cards
- [ ] My ticket shows status badge at `/account/ticket`
- [ ] QR displays when ticket approved/admin-granted
- [ ] Upgrade flow at `/account/ticket/upgrade` (if eligible)
- [ ] Purchase/payment at `/ticket/purchase` — order/summary cards dark style
- [ ] With `MOCK_TICKET_MODE=false`: tiers/purchase hit real API

## Thông báo (API)

- [ ] List loads from `GET /notifications` at `/account/notifications`
- [ ] Tap item → detail at `/account/notifications/:id`
- [ ] Unread items marked read on detail open (`PUT` mark_read)

## Profile & submissions

- [ ] Profile mint card layout at `/account/profile`
- [ ] Edit profile saves
- [ ] Settings: theme + locale toggles work
- [ ] Change password submits to API
- [ ] Submissions hub lists panel/talent/conbook
- [ ] Dealer booth + staff pages (if dealer role)

## Lost & Found

- [ ] Public list/search at `/lost-found`
- [ ] Item detail at `/lost-found/:id`
- [ ] Report form at `/lost-found/report`
- [ ] Track request at `/lost-found/requests/:id`

## Theme & i18n

- [ ] Dark theme: canvas `#131313`, explore ticket cards dark/premium gold accents
- [ ] Bottom nav blur + `#07131A` background
- [ ] Be Vietnam Pro typography
- [ ] VI/EN labels on nav and new screens

## Regression

- [ ] Unverified user restricted to profile + change-password + settings
- [ ] Staff/admin login still routes to `/admin`
- [ ] Landing (`/`), auth, payment screens unchanged
