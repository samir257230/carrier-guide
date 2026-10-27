CAMPUS GUIDE — WEBSITE SETUP (SIMPLE HINDI GUIDE)
=================================================

IS ZIP MEIN KYA HAI?
- index.html: website ka design aur functionality
- campus-guide-logo.jpeg: aapka diya hua logo
- supabase-config.js: backend URL aur public key yahan paste karni hai
- supabase-schema.sql: student profiles, institutions, feedback aur mentorship database tables
- institutions-template.csv: institute data bharne ka example format

IMPORTANT: Abhi website ka preview khul jayega. Real OTP/login/tabhi kaam karega jab aap apna Supabase project connect karenge. Bina apne backend ke website email/SMS code bhej nahi sakti. Is ZIP mein aapke private credentials shamil nahi hain.

STEP 1 — SUPABASE PROJECT BANAYEIN
1. https://supabase.com par account banayein aur New Project create karein.
2. Project dashboard khulne par SQL Editor par jayein.
3. Is ZIP ki supabase-schema.sql file ka poora code copy karke SQL Editor mein paste karein aur Run dabayein.

STEP 2 — EMAIL OTP CONFIGURE KAREIN
1. Supabase dashboard → Authentication → Email Templates kholein.
2. Magic Link / OTP template mein {{ .ConfirmationURL }} ke bajaye OTP code dikhayein: {{ .Token }}.
   Example text: <h2>Campus Guide verification code</h2><p>Your code is {{ .Token }}</p>
3. Agar Confirm Signup template bhi chal raha hai, use bhi OTP template ke taur par set karein.
4. Production ke liye apna SMTP provider configure karein; default email sending testing ke liye limited ho sakti hai.

STEP 3 — PHONE OTP CONFIGURE KAREIN (OPTIONAL)
1. Supabase → Authentication → Providers/Sign In → Phone enable karein.
2. Supported SMS provider ke credentials set karein.
3. India mein live launch se pehle SMS provider, sender ID, DLT templates aur applicable telecom requirements verify karein.
4. Phone number international format mein enter hoga, jaise +91XXXXXXXXXX.

STEP 4 — SUPABASE URL AUR PUBLIC KEY LAGAYEIN
1. Supabase dashboard → Project Settings → API / API Keys par jayein.
2. Project URL copy karein.
3. Anon/publishable public key copy karein. SERVICE_ROLE/secret key kabhi website mein paste na karein.
4. Is folder mein supabase-config.js open karein aur do values replace karein:
   SUPABASE_URL: "https://YOUR-PROJECT.supabase.co"
   SUPABASE_ANON_KEY: "YOUR-PUBLIC-ANON-OR-PUBLISHABLE-KEY"
5. File save karein.

STEP 5 — WEBSITE VERCEL PAR UPDATE KAREIN
1. Folder ke saare files GitHub repository ke root/main folder mein upload karein. Folder ke andar ek aur extra folder na banayein.
2. Ensure karein ki index.html, campus-guide-logo.jpeg aur supabase-config.js ek hi root level par hain.
3. GitHub commit karein. Agar repository Vercel se connected hai toh deploy/redeploy ho jayega.
4. Deployment ke baad website open karke Ctrl + F5 dabayein.

STEP 6 — INSTITUTE DATA ADD KAREIN
1. Supabase → Table Editor → institutions kholein.
2. Har Central University, IIT aur NIT ke liye ek row add karein. Institution name, exact type, state, official site, available streams, levels (UG/PG/PhD), subjects aur research areas bharein.
3. Research/hostel/food ratings ko bina checked student feedback ke mat bharein. Scores khaali reh sakte hain.
4. profile_status ko shuru mein directory_only rakhein. Verified student insights approve hone ke baad hi published karein.
5. CSV import bhi use kar sakte hain. institutions-template.csv mein sirf column headers hain; official institution rows add karne ke baad hi import karein.

STUDENT FLOW
- Create account → email/phone OTP bheja jayega → student code verify karega → password aur confirm password set karega → student profile bharega.
- Profile mein stream, highest qualification, target UG/PG/PhD, subject, preferred institute type aur state save hoga.
- Login ke baad saved profile ke basis par filters set honge.
- Logout ke baad session end hoga; agle login mein verified email/phone + password use hoga.
- Student feedback Supabase mein pending moderation ke liye save hota hai; approved hone se pehle public nahi hota.

SECURITY NOTES
- Frontend mein sirf public/anon key use karein. Service-role key bilkul nahi.
- SQL schema Row Level Security use karta hai; public page institution records read kar sakta hai lekin public browser se institution data edit nahi kar sakta.
- Is starter pack mein public admin dashboard nahi hai. Institution records aur review approval Supabase dashboard se manage karein, ya baad mein role-protected admin panel banayein.
- Preview mode mein OTP ya password login real nahi hota. Supabase connect karne ke baad hi test karein.

Official current starting points:
Supabase Auth docs: https://supabase.com/docs/guides/auth
Supabase email OTP docs: https://supabase.com/docs/guides/auth/auth-email-passwordless
UGC central universities: https://www.ugc.gov.in/
Ministry of Education institutions: https://www.education.gov.in/
