/**
 * ==========================================================================
 * "टीम गोपालसिंह – हरनावदा गजा" Web Admin Dashboard Main Controller
 * Complete JS Module managing RBAC, Complaints, Dev Works, Officers,
 * Election Data (AC-198), Verification Workflow, Audit Logs, and Analytics.
 * ==========================================================================
 */

// --- 1. LOCAL STORAGE & INITIAL SEED DATA ---
const STORAGE_KEYS = {
  SETTINGS: 'tg_app_settings',
  ROLE: 'tg_active_role',
  COMPLAINTS: 'tg_complaints_data',
  DEV_WORKS: 'tg_devworks_data',
  OFFICERS: 'tg_officers_data',
  BOOTHS: 'tg_booths_data',
  SOCIALS: 'tg_socials_data',
  AUDIT_LOGS: 'tg_audit_logs'
};

// Seed Data Initialization
function initLocalStorageSeed() {
  if (!localStorage.getItem(STORAGE_KEYS.SETTINGS)) {
    const defaultSettings = {
      siteName: "टीम गोपालसिंह – हरनावदा गजा",
      samparkUrl: "https://sampark.rajasthan.gov.in/",
      disclaimerText: "यह एक स्वतंत्र सामाजिक एवं विकास सेवा मंच है। यह किसी भी सरकारी विभाग का आधिकारिक पोर्टल नहीं है। सरकारी शिकायत पंजीकरण हेतु राजस्थान सम्पर्क पोर्टल (181) का उपयोग करें।",
      helpline: "+91 98290 12345"
    };
    localStorage.setItem(STORAGE_KEYS.SETTINGS, JSON.stringify(defaultSettings));
  }

  if (!localStorage.getItem(STORAGE_KEYS.ROLE)) {
    localStorage.setItem(STORAGE_KEYS.ROLE, "SUPER_ADMIN");
  }

  if (!localStorage.getItem(STORAGE_KEYS.COMPLAINTS)) {
    const defaultComplaints = [
      {
        id: "CMP-1001",
        citizenName: "रामेश्वर गुर्जर",
        phone: "+91 98291 44556",
        ward: "हरनावदा गजा",
        category: "जल आपूर्ति",
        subject: "मुख्य बस स्टैंड के पास पेयजल पाइपलाइन लीकेज समस्या",
        details: "पिछले 4 दिनों से मुख्य पाइपलाइन में लीकेज होने से सड़कों पर पानी बह रहा है और सप्लाई में प्रेशर कम आ रहा है।",
        status: "Action Taken",
        date: "2026-08-10",
        assignedOfficer: "अभियंता - जन स्वास्थ्य अभियान्त्रिकी विभाग (PHED)",
        remarks: ["10 अगस्त: शिकायत दर्ज हुई।", "11 अगस्त: PHED कनिष्ठ अभियंता को प्रेषित किया गया।"]
      },
      {
        id: "CMP-1002",
        citizenName: "सीता देवी राठौड़",
        phone: "+91 94142 88990",
        ward: "हरनावदा गजा",
        category: "विद्युत",
        subject: "स्कूल रोड पर स्ट्रीट लाइट खराब",
        details: "राजकीय उच्च माध्यमिक विद्यालय मार्ग पर 3 स्ट्रीट लाइटें जल नहीं रही हैं, रात में दुर्घटना का खतरा बना रहता है।",
        status: "New",
        date: "2026-08-12",
        assignedOfficer: "अनअसाइन",
        remarks: ["12 अगस्त: शिकायत दर्ज।"]
      },
      {
        id: "CMP-1003",
        citizenName: "मोहनलाल मीना",
        phone: "+91 97850 11223",
        ward: "झालरापाटन",
        category: "सड़क व नालियां",
        subject: "ग्राम पंचायत भवन के पास गंदे पानी की नाली अवरुद्ध",
        details: "नाली की सफाई न होने से जलभराव हो रहा है। मच्छर पनपने की सम्भावना है।",
        status: "Resolved",
        date: "2026-08-05",
        assignedOfficer: "विकास अधिकारी - झालरापाटन पंचायत समिति",
        remarks: ["5 अगस्त: शिकायत प्राप्त हुई।", "7 अगस्त: सफाई कर्मचारी टीम भेजी गई।", "8 अगस्त: नाली की सफाई पूर्ण और निस्तारित दर्ज।"]
      }
    ];
    localStorage.setItem(STORAGE_KEYS.COMPLAINTS, JSON.stringify(defaultComplaints));
  }

  if (!localStorage.getItem(STORAGE_KEYS.DEV_WORKS)) {
    const defaultDevWorks = [
      {
        id: "DEV-201",
        title: "हरनावदा गजा मुख्य मार्ग सीसी रोड एवं नाली निर्माण",
        location: "हरनावदा गजा",
        sanctionAmount: "25.00",
        progress: 65,
        status: "निर्माणाधीन",
        sourceUrl: "https://jhalawar.rajasthan.gov.in/dev-project-201",
        verified: true,
        photos: {
          before: "https://via.placeholder.com/150/101E3D/D4AF37?text=Before+Road",
          inProgress: "https://via.placeholder.com/150/101E3D/D4AF37?text=Work+In+Progress",
          after: "https://via.placeholder.com/150/101E3D/D4AF37?text=After+Road"
        }
      },
      {
        id: "DEV-202",
        title: "सार्वजनिक पेयजल बोरवेल एवं सौर ऊर्जा पंप स्थापना",
        location: "हरनावदा गजा (गुर्जर ढाणी)",
        sanctionAmount: "8.50",
        progress: 100,
        status: "पूर्ण",
        sourceUrl: "https://jhalawar.rajasthan.gov.in/dev-project-202",
        verified: true,
        photos: {
          before: "https://via.placeholder.com/150/101E3D/D4AF37?text=Old+Pump",
          inProgress: "https://via.placeholder.com/150/101E3D/D4AF37?text=Solar+Install",
          after: "https://via.placeholder.com/150/101E3D/D4AF37?text=Completed+Borewell"
        }
      },
      {
        id: "DEV-203",
        title: "खेल मैदान समतलीकरण एवं बाउंड्री वॉल निर्माण",
        location: "हरनावदा गजा विद्यालय परिसर",
        sanctionAmount: "12.00",
        progress: 10,
        status: "स्वीकृत",
        sourceUrl: "https://jhalawar.rajasthan.gov.in/dev-project-203-draft",
        verified: false,
        photos: {
          before: "https://via.placeholder.com/150/101E3D/D4AF37?text=Ground+Before",
          inProgress: "https://via.placeholder.com/150/101E3D/D4AF37?text=Leveling",
          after: "https://via.placeholder.com/150/101E3D/D4AF37?text=Future+Wall"
        }
      }
    ];
    localStorage.setItem(STORAGE_KEYS.DEV_WORKS, JSON.stringify(defaultDevWorks));
  }

  if (!localStorage.getItem(STORAGE_KEYS.OFFICERS)) {
    const defaultOfficers = [
      {
        id: "OFF-301",
        name: "श्री अजय कुमार मीना",
        designation: "उपखण्ड अधिकारी (SDM)",
        department: "राजस्व एवं प्रशासनिक विभाग",
        phone: "+91 94140 12345",
        email: "sdm.jhalrapatan@rajasthan.gov.in",
        office: "उपखण्ड कार्यालय, झालरापाटन",
        sourceUrl: "https://jhalawar.rajasthan.gov.in/officer-directory/sdm-jhalrapatan",
        status: "Verified"
      },
      {
        id: "OFF-302",
        name: "ईं. दिनेश गुप्ता",
        designation: "अधिशासी अभियंता (XEn)",
        department: "सार्वजनिक निर्माण विभाग (PWD)",
        phone: "+91 98290 67890",
        email: "xen.pwd.jhalawar@rajasthan.gov.in",
        office: "PWD डिविजन झालावाड़",
        sourceUrl: "https://pwd.rajasthan.gov.in/directory/xen-jhalawar",
        status: "Verified"
      },
      {
        id: "OFF-303",
        name: "डॉ. विक्रम सिंह",
        designation: "विकास अधिकारी (BDO)",
        department: "पंचायत समिति झालरापाटन",
        phone: "+91 94133 45678",
        email: "bdo.jhalrapatan@rajasthan.gov.in",
        office: "पंचायत समिति झालरापाटन",
        sourceUrl: "https://jhalawar.rajasthan.gov.in/directory/bdo-draft",
        status: "Draft"
      }
    ];
    localStorage.setItem(STORAGE_KEYS.OFFICERS, JSON.stringify(defaultOfficers));
  }

  if (!localStorage.getItem(STORAGE_KEYS.BOOTHS)) {
    const defaultBooths = [
      {
        boothNo: "142",
        name: "राजकीय उच्च माध्यमिक विद्यालय, हरनावदा गजा (पूर्वी भाग)",
        totalVoters: 984,
        maleVoters: 512,
        femaleVoters: 472,
        turnoutPercent: "82.4%",
        issues: "पेयजल सप्लाई प्रेशर, सीसी रोड विस्तार"
      },
      {
        boothNo: "143",
        name: "राजकीय प्राथमिक विद्यालय, हरनावदा गजा (पश्चिमी भाग)",
        totalVoters: 850,
        maleVoters: 438,
        femaleVoters: 412,
        turnoutPercent: "79.1%",
        issues: "नाली सफाई, आंगनवाड़ी भवन मरम्मत"
      },
      {
        boothNo: "144",
        name: "ग्राम पंचायत भवन, बघेर",
        totalVoters: 1120,
        maleVoters: 580,
        femaleVoters: 540,
        turnoutPercent: "84.2%",
        issues: "सब-सेंटर स्वास्थ्य सुविधा, विद्युत ट्रांसफार्मर"
      }
    ];
    localStorage.setItem(STORAGE_KEYS.BOOTHS, JSON.stringify(defaultBooths));
  }

  if (!localStorage.getItem(STORAGE_KEYS.SOCIALS)) {
    const defaultSocials = [
      { id: "SOC-1", platform: "WhatsApp", title: "टीम गोपालसिंह आधिकारिक व्हाट्सएप्प ग्रुप", link: "https://wa.me/919829012345", active: true },
      { id: "SOC-2", platform: "Call", title: "जनसेवा 24/7 हेल्पलाइन कॉल सेंटर", link: "+91 98290 12345", active: true },
      { id: "SOC-3", platform: "Facebook", title: "टीम गोपालसिंह - हरनावदा गजा फ़ेसबुक पेज", link: "https://facebook.com/teamgopalsingh.harnawada", active: true },
      { id: "SOC-4", platform: "YouTube", title: "हरनावदा गजा विकास एवं समाचार यूट्यूब चैनल", link: "https://youtube.com/@teamgopalsingh", active: true },
      { id: "SOC-5", platform: "Instagram", title: "टीम गोपालसिंह इंस्टाग्राम अपडेट्स", link: "https://instagram.com/teamgopalsingh_official", active: true }
    ];
    localStorage.setItem(STORAGE_KEYS.SOCIALS, JSON.stringify(defaultSocials));
  }

  if (!localStorage.getItem(STORAGE_KEYS.AUDIT_LOGS)) {
    const defaultLogs = [
      {
        id: "LOG-5001",
        adminId: "ADMIN-SUPER",
        action: "सिस्टम लॉगिन एवं सेटिंग्स अद्यतन",
        timestamp: "2026-08-12 10:15:22",
        target: "App Configuration"
      },
      {
        id: "LOG-5002",
        adminId: "ADMIN-CMP",
        action: "शिकायत CMP-1001 की स्थिति 'Action Taken' में अपडेट की गई",
        timestamp: "2026-08-11 14:30:10",
        target: "CMP-1001"
      }
    ];
    localStorage.setItem(STORAGE_KEYS.AUDIT_LOGS, JSON.stringify(defaultLogs));
  }
}

initLocalStorageSeed();

// --- 2. RBAC ACCESS CONTROL ENGINE ---
const ROLES = {
  SUPER_ADMIN: {
    title: "Super Admin (सुपर एडमिन)",
    badge: "सुपर एडमिन",
    accessViews: ["overview-view", "complaints-view", "dev-works-view", "officers-view", "election-data-view", "social-media-view", "verification-view", "audit-logs-view", "reports-view", "settings-view"],
    canEdit: true,
    canDelete: true,
    canPublish: true
  },
  COMPLAINT_ADMIN: {
    title: "Complaint Admin (शिकायत एडमिन)",
    badge: "शिकायत एडमिन",
    accessViews: ["overview-view", "complaints-view", "officers-view", "reports-view"],
    canEdit: true,
    canDelete: false,
    canPublish: false
  },
  DEV_ADMIN: {
    title: "Development Admin (विकास एडमिन)",
    badge: "विकास एडमिन",
    accessViews: ["overview-view", "dev-works-view", "officers-view", "reports-view"],
    canEdit: true,
    canDelete: false,
    canPublish: false
  },
  ELECTION_ADMIN: {
    title: "Election Data Admin (चुनाव डेटा एडमिन)",
    badge: "चुनाव एडमिन",
    accessViews: ["overview-view", "election-data-view", "reports-view"],
    canEdit: true,
    canDelete: false,
    canPublish: false
  },
  VERIFICATION_ADMIN: {
    title: "Verification Admin (सत्यापन एडमिन)",
    badge: "सत्यापन एडमिन",
    accessViews: ["overview-view", "verification-view", "officers-view", "dev-works-view"],
    canEdit: true,
    canDelete: false,
    canPublish: true
  }
};

let currentRoleKey = localStorage.getItem(STORAGE_KEYS.ROLE) || "SUPER_ADMIN";

function applyRBAC() {
  const roleConfig = ROLES[currentRoleKey] || ROLES.SUPER_ADMIN;
  
  // Update Header UI
  document.getElementById('currentRoleTitle').innerText = roleConfig.title;
  document.getElementById('userBadgeDisplay').innerText = roleConfig.badge;
  document.getElementById('rbacSelect').value = currentRoleKey;
  
  // Navigation Links Visibility
  const navLinks = document.querySelectorAll('.sidebar-nav .nav-link');
  navLinks.forEach(link => {
    const targetView = link.getAttribute('data-view');
    if (roleConfig.accessViews.includes(targetView)) {
      link.style.display = 'flex';
    } else {
      link.style.display = 'none';
    }
  });

  // Ensure active view is permitted
  const activeLink = document.querySelector('.sidebar-nav .nav-link.active');
  if (activeLink && activeLink.style.display === 'none') {
    const firstAllowedView = roleConfig.accessViews[0];
    switchView(firstAllowedView);
  }
}

// Log Action Helper
function logAuditAction(actionText, targetRecord = "N/A") {
  const logs = JSON.parse(localStorage.getItem(STORAGE_KEYS.AUDIT_LOGS) || "[]");
  const newLog = {
    id: "LOG-" + Math.floor(1000 + Math.random() * 9000),
    adminId: "ADMIN-" + currentRoleKey.split('_')[0],
    action: actionText,
    timestamp: new Date().toISOString().replace('T', ' ').substring(0, 19),
    target: targetRecord
  };
  logs.unshift(newLog);
  localStorage.setItem(STORAGE_KEYS.AUDIT_LOGS, JSON.stringify(logs));
  renderAuditLogs();
}

// --- 3. UI CONTROLLER & VIEW SWITCHING ---
function switchView(viewId) {
  const views = document.querySelectorAll('.view-section');
  views.forEach(v => v.classList.remove('active'));
  
  const targetView = document.getElementById(viewId);
  if (targetView) targetView.classList.add('active');

  const navLinks = document.querySelectorAll('.sidebar-nav .nav-link');
  navLinks.forEach(l => {
    if (l.getAttribute('data-view') === viewId) {
      l.classList.add('active');
      const titleSpan = l.querySelector('span');
      if (titleSpan) {
        document.getElementById('currentPageTitle').innerText = titleSpan.innerText;
      }
    } else {
      l.classList.remove('active');
    }
  });

  // Render view data
  renderAllViews();
}

function renderAllViews() {
  renderOverview();
  renderComplaintsTable();
  renderDevWorksTable();
  renderOfficersTable();
  renderBoothsTable();
  renderSocialMediaTable();
  renderVerificationQueue();
  renderAuditLogs();
  updateBadges();
}

function updateBadges() {
  const complaints = JSON.parse(localStorage.getItem(STORAGE_KEYS.COMPLAINTS) || "[]");
  const activeComplaintsCount = complaints.filter(c => c.status !== 'Resolved' && c.status !== 'Closed').length;
  document.getElementById('complaintsBadge').innerText = activeComplaintsCount;

  const officers = JSON.parse(localStorage.getItem(STORAGE_KEYS.OFFICERS) || "[]");
  const devWorks = JSON.parse(localStorage.getItem(STORAGE_KEYS.DEV_WORKS) || "[]");
  const unverifiedCount = officers.filter(o => o.status === 'Draft').length + devWorks.filter(d => !d.verified).length;
  document.getElementById('verificationBadge').innerText = unverifiedCount;
}

// --- 4. OVERVIEW MODULE ---
function renderOverview() {
  const complaints = JSON.parse(localStorage.getItem(STORAGE_KEYS.COMPLAINTS) || "[]");
  const devWorks = JSON.parse(localStorage.getItem(STORAGE_KEYS.DEV_WORKS) || "[]");
  const officers = JSON.parse(localStorage.getItem(STORAGE_KEYS.OFFICERS) || "[]");
  const socials = JSON.parse(localStorage.getItem(STORAGE_KEYS.SOCIALS) || "[]");

  document.getElementById('statTotalComplaints').innerText = complaints.length;
  const resolvedCount = complaints.filter(c => c.status === 'Resolved' || c.status === 'Closed').length;
  document.getElementById('statResolvedComplaints').innerText = resolvedCount;
  const resolvedPercent = complaints.length > 0 ? Math.round((resolvedCount / complaints.length) * 100) : 0;
  document.getElementById('statResolvedRate').innerText = resolvedPercent + "%";

  document.getElementById('statDevProjects').innerText = devWorks.length;
  const activeDev = devWorks.filter(d => d.status === 'निर्माणाधीन').length;
  document.getElementById('statDevActive').innerText = activeDev + " निर्माणाधीन";

  const unverifiedCount = officers.filter(o => o.status === 'Draft').length + devWorks.filter(d => !d.verified).length;
  document.getElementById('statPendingVerification').innerText = unverifiedCount;

  // Recent complaints table
  const tbody = document.querySelector('#recentComplaintsTable tbody');
  if (tbody) {
    tbody.innerHTML = '';
    complaints.slice(0, 5).forEach(c => {
      const tr = document.createElement('tr');
      tr.innerHTML = `
        <td><strong>${c.id}</strong></td>
        <td>${c.citizenName}<br><small class="text-muted">${c.phone}</small></td>
        <td>${c.subject}<br><small style="color: var(--gold-light);">${c.ward}</small></td>
        <td><span class="badge badge-${getBadgeClass(c.status)}">${c.status}</span></td>
        <td><button class="btn btn-sm btn-outline-gold" onclick="openComplaintModal('${c.id}')"><i class="fa-solid fa-eye"></i> देखें</button></td>
      `;
      tbody.appendChild(tr);
    });
  }

  // Socials list
  const socialBox = document.getElementById('overviewSocialList');
  if (socialBox) {
    socialBox.innerHTML = '';
    socials.forEach(s => {
      const item = document.createElement('div');
      item.style.cssText = "display: flex; align-items: center; justify-content: space-between; padding: 8px 0; border-bottom: 1px solid var(--border-color);";
      item.innerHTML = `
        <div>
          <strong style="color: var(--gold-light); font-size: 0.85rem;"><i class="${getSocialIcon(s.platform)}"></i> ${s.title}</strong>
          <div style="font-size: 0.75rem; color: var(--text-muted);">${s.link}</div>
        </div>
        <span class="badge badge-${s.active ? 'resolved' : 'closed'}">${s.active ? 'सक्रिय' : 'निष्क्रिय'}</span>
      `;
      socialBox.appendChild(item);
    });
  }
}

function getBadgeClass(status) {
  switch (status) {
    case 'New': return 'new';
    case 'Under Review': return 'review';
    case 'Forwarded': return 'forwarded';
    case 'Action Taken': return 'action';
    case 'Resolved': return 'resolved';
    case 'Closed': return 'closed';
    case 'Verified': return 'verified';
    case 'Draft': return 'draft';
    default: return 'pending';
  }
}

function getSocialIcon(platform) {
  switch (platform) {
    case 'WhatsApp': return 'fa-brands fa-whatsapp';
    case 'Call': return 'fa-solid fa-phone-volume';
    case 'Facebook': return 'fa-brands fa-facebook';
    case 'Instagram': return 'fa-brands fa-instagram';
    case 'YouTube': return 'fa-brands fa-youtube';
    case 'Twitter': return 'fa-brands fa-x-twitter';
    default: return 'fa-solid fa-link';
  }
}

// --- 5. COMPLAINT MANAGEMENT MODULE ---
function renderComplaintsTable() {
  const complaints = JSON.parse(localStorage.getItem(STORAGE_KEYS.COMPLAINTS) || "[]");
  const wardFilter = document.getElementById('complaintWardFilter').value;
  const statusFilter = document.getElementById('complaintStatusFilter').value;

  const filtered = complaints.filter(c => {
    const matchWard = wardFilter === 'ALL' || c.ward === wardFilter;
    const matchStatus = statusFilter === 'ALL' || c.status === statusFilter;
    return matchWard && matchStatus;
  });

  const tbody = document.querySelector('#complaintsMainTable tbody');
  if (!tbody) return;
  tbody.innerHTML = '';

  filtered.forEach(c => {
    const tr = document.createElement('tr');
    tr.innerHTML = `
      <td><strong>${c.id}</strong></td>
      <td>${c.citizenName}</td>
      <td>${c.phone}</td>
      <td>${c.ward}</td>
      <td><span class="badge badge-pending">${c.category}</span></td>
      <td><span class="badge badge-${getBadgeClass(c.status)}">${c.status}</span></td>
      <td>${c.date}</td>
      <td>
        <button class="btn btn-sm btn-outline-gold" onclick="openComplaintModal('${c.id}')"><i class="fa-solid fa-pen-to-square"></i> कार्रवाई करें</button>
      </td>
    `;
    tbody.appendChild(tr);
  });
}

function openComplaintModal(id) {
  const complaints = JSON.parse(localStorage.getItem(STORAGE_KEYS.COMPLAINTS) || "[]");
  const officers = JSON.parse(localStorage.getItem(STORAGE_KEYS.OFFICERS) || "[]");
  const complaint = complaints.find(c => c.id === id);
  if (!complaint) return;

  const modalBody = document.getElementById('complaintModalBody');
  modalBody.innerHTML = `
    <div style="margin-bottom: 16px;">
      <h3 style="color: var(--gold-light); font-size: 1.1rem; margin-bottom: 6px;">${complaint.subject}</h3>
      <p style="font-size: 0.85rem; color: var(--text-main); background: var(--bg-primary); padding: 10px; border-radius: var(--radius-sm); border: 1px solid var(--border-color);">${complaint.details}</p>
    </div>

    <div class="form-row" style="margin-bottom: 16px;">
      <div><strong>शिकायतकर्ता:</strong> ${complaint.citizenName} (${complaint.phone})</div>
      <div><strong>वार्ड / स्थान:</strong> ${complaint.ward}</div>
      <div><strong>श्रेणी:</strong> ${complaint.category}</div>
    </div>

    <div class="form-group">
      <label class="form-label">अधिकारी को फॉरवर्ड करें (Forward to Govt Officer)</label>
      <select class="form-select" id="modalAssignOfficer">
        <option value="अनअसाइन">-- अधिकारी चुनें --</option>
        ${officers.map(o => `<option value="${o.designation} (${o.department})" ${complaint.assignedOfficer.includes(o.designation) ? 'selected' : ''}>${o.name} - ${o.designation}</option>`).join('')}
      </select>
    </div>

    <div class="form-group">
      <label class="form-label">स्थिति बदलें (Update Pipeline Status)</label>
      <select class="form-select" id="modalComplaintStatus">
        <option value="New" ${complaint.status === 'New' ? 'selected' : ''}>New (नई शिकायत)</option>
        <option value="Under Review" ${complaint.status === 'Under Review' ? 'selected' : ''}>Under Review (समीक्षाधीन)</option>
        <option value="Forwarded" ${complaint.status === 'Forwarded' ? 'selected' : ''}>Forwarded (अधिकारी को प्रेषित)</option>
        <option value="Action Taken" ${complaint.status === 'Action Taken' ? 'selected' : ''}>Action Taken (कार्रवाई जारी)</option>
        <option value="Resolved" ${complaint.status === 'Resolved' ? 'selected' : ''}>Resolved (निस्तारित)</option>
        <option value="Closed" ${complaint.status === 'Closed' ? 'selected' : ''}>Closed (बंद)</option>
      </select>
    </div>

    <div class="form-group">
      <label class="form-label">नया प्रशासनिक रिमार्क (Add Admin Remark)</label>
      <input type="text" class="form-control" id="modalNewRemark" placeholder="उदा. अधिकारी द्वारा टीम मौके पर रवाना की गई।">
    </div>

    <div>
      <label class="form-label">कार्रवाई का इतिहास (Timeline Remarks)</label>
      <ul style="font-size: 0.8rem; color: var(--text-muted); padding-left: 18px;">
        ${complaint.remarks.map(r => `<li style="margin-bottom: 4px;">${r}</li>`).join('')}
      </ul>
    </div>
  `;

  document.getElementById('saveComplaintActionBtn').onclick = function() {
    saveComplaintAction(id);
  };

  openModal('complaintModal');
}

function saveComplaintAction(id) {
  const complaints = JSON.parse(localStorage.getItem(STORAGE_KEYS.COMPLAINTS) || "[]");
  const index = complaints.findIndex(c => c.id === id);
  if (index === -1) return;

  const assignedOfficer = document.getElementById('modalAssignOfficer').value;
  const newStatus = document.getElementById('modalComplaintStatus').value;
  const newRemarkText = document.getElementById('modalNewRemark').value.trim();

  complaints[index].assignedOfficer = assignedOfficer;
  complaints[index].status = newStatus;
  
  if (newRemarkText) {
    const todayStr = new Date().toLocaleDateString('hi-IN');
    complaints[index].remarks.push(`${todayStr}: ${newRemarkText}`);
  }

  localStorage.setItem(STORAGE_KEYS.COMPLAINTS, JSON.stringify(complaints));
  logAuditAction(`शिकायत ${id} की स्थिति अद्यतन की गई: ${newStatus}`, id);
  closeModal('complaintModal');
  renderComplaintsTable();
  renderOverview();
}

// --- 6. DEVELOPMENT WORK TRACKER MODULE ---
function renderDevWorksTable() {
  const devWorks = JSON.parse(localStorage.getItem(STORAGE_KEYS.DEV_WORKS) || "[]");
  const tbody = document.querySelector('#devWorksTable tbody');
  if (!tbody) return;
  tbody.innerHTML = '';

  devWorks.forEach(d => {
    const tr = document.createElement('tr');
    tr.innerHTML = `
      <td><strong>${d.id}</strong></td>
      <td>${d.title}<br><small style="color: var(--gold-light);">${d.location}</small></td>
      <td>₹ ${d.sanctionAmount} लाख</td>
      <td style="width: 180px;">
        <div class="progress-container">
          <div style="font-size: 0.75rem; color: var(--text-muted); margin-bottom: 2px;">${d.progress}% पूर्ण</div>
          <div class="progress-bar-bg">
            <div class="progress-bar-fill" style="width: ${d.progress}%;"></div>
          </div>
        </div>
      </td>
      <td><span class="badge badge-${d.status === 'पूर्ण' ? 'resolved' : (d.status === 'निर्माणाधीन' ? 'action' : 'draft')}">${d.status}</span></td>
      <td>
        <span class="badge badge-${d.verified ? 'verified' : 'draft'}">${d.verified ? 'सत्यापित' : 'लंबित'}</span>
      </td>
      <td>
        <button class="btn btn-sm btn-outline-gold" onclick="openEditDevWorkModal('${d.id}')"><i class="fa-solid fa-pen"></i> एडिट</button>
        <button class="btn btn-sm btn-danger" onclick="deleteDevWork('${d.id}')"><i class="fa-solid fa-trash"></i></button>
      </td>
    `;
    tbody.appendChild(tr);
  });
}

function openAddDevWorkModal() {
  document.getElementById('devWorkId').value = '';
  document.getElementById('devTitle').value = '';
  document.getElementById('devLocation').value = 'हरनावदा गजा';
  document.getElementById('devAmount').value = '';
  document.getElementById('devProgress').value = 0;
  document.getElementById('progressValDisplay').innerText = '0%';
  document.getElementById('devStatus').value = 'स्वीकृत';
  openModal('devWorkModal');
}

function openEditDevWorkModal(id) {
  const devWorks = JSON.parse(localStorage.getItem(STORAGE_KEYS.DEV_WORKS) || "[]");
  const dev = devWorks.find(d => d.id === id);
  if (!dev) return;

  document.getElementById('devWorkId').value = dev.id;
  document.getElementById('devTitle').value = dev.title;
  document.getElementById('devLocation').value = dev.location;
  document.getElementById('devAmount').value = dev.sanctionAmount;
  document.getElementById('devProgress').value = dev.progress;
  document.getElementById('progressValDisplay').innerText = dev.progress + '%';
  document.getElementById('devStatus').value = dev.status;
  openModal('devWorkModal');
}

function saveDevWorkForm() {
  const id = document.getElementById('devWorkId').value;
  const title = document.getElementById('devTitle').value.trim();
  const location = document.getElementById('devLocation').value.trim();
  const sanctionAmount = document.getElementById('devAmount').value;
  const progress = parseInt(document.getElementById('devProgress').value) || 0;
  const status = document.getElementById('devStatus').value;

  if (!title || !sanctionAmount) {
    alert("कृपया कार्य का शीर्षक एवं स्वीकृत राशि दर्ज करें।");
    return;
  }

  const devWorks = JSON.parse(localStorage.getItem(STORAGE_KEYS.DEV_WORKS) || "[]");

  if (id) {
    const index = devWorks.findIndex(d => d.id === id);
    if (index !== -1) {
      devWorks[index].title = title;
      devWorks[index].location = location;
      devWorks[index].sanctionAmount = sanctionAmount;
      devWorks[index].progress = progress;
      devWorks[index].status = status;
      logAuditAction(`विकास कार्य ${id} अद्यतन किया गया (${progress}%)`, id);
    }
  } else {
    const newDev = {
      id: "DEV-" + Math.floor(200 + Math.random() * 800),
      title,
      location,
      sanctionAmount,
      progress,
      status,
      sourceUrl: "https://jhalawar.rajasthan.gov.in/dev-project-draft",
      verified: false,
      photos: {
        before: "https://via.placeholder.com/150/101E3D/D4AF37?text=Before",
        inProgress: "https://via.placeholder.com/150/101E3D/D4AF37?text=In+Progress",
        after: "https://via.placeholder.com/150/101E3D/D4AF37?text=After"
      }
    };
    devWorks.unshift(newDev);
    logAuditAction(`नया विकास कार्य जोड़ा गया: ${title}`, newDev.id);
  }

  localStorage.setItem(STORAGE_KEYS.DEV_WORKS, JSON.stringify(devWorks));
  closeModal('devWorkModal');
  renderDevWorksTable();
  renderOverview();
}

function deleteDevWork(id) {
  if (!confirm("क्या आप इस विकास कार्य रिकॉर्ड को हटाना चाहते हैं?")) return;
  let devWorks = JSON.parse(localStorage.getItem(STORAGE_KEYS.DEV_WORKS) || "[]");
  devWorks = devWorks.filter(d => d.id !== id);
  localStorage.setItem(STORAGE_KEYS.DEV_WORKS, JSON.stringify(devWorks));
  logAuditAction(`विकास कार्य हटा दिया गया: ${id}`, id);
  renderDevWorksTable();
  renderOverview();
}

// --- 7. GOVERNMENT OFFICER DIRECTORY MODULE ---
function renderOfficersTable() {
  const officers = JSON.parse(localStorage.getItem(STORAGE_KEYS.OFFICERS) || "[]");
  const tbody = document.querySelector('#officersTable tbody');
  if (!tbody) return;
  tbody.innerHTML = '';

  officers.forEach(o => {
    const tr = document.createElement('tr');
    tr.innerHTML = `
      <td><strong>${o.name}</strong></td>
      <td>${o.designation}<br><small style="color: var(--text-muted);">${o.department}</small></td>
      <td>${o.phone}<br><small style="color: var(--gold-light);">${o.email}</small></td>
      <td>${o.office}</td>
      <td><a href="${o.sourceUrl}" target="_blank" style="color: #60A5FA; font-size: 0.8rem;"><i class="fa-solid fa-arrow-up-right-from-square"></i> आधिकारिक लिंक</a></td>
      <td><span class="badge badge-${o.status === 'Verified' ? 'verified' : 'draft'}">${o.status}</span></td>
      <td>
        <button class="btn btn-sm btn-secondary" onclick="triggerOfficerEmail('${o.email}', '${o.name}')" title="ईमेल भेजें"><i class="fa-solid fa-envelope"></i></button>
        <button class="btn btn-sm btn-outline-gold" onclick="openEditOfficerModal('${o.id}')"><i class="fa-solid fa-pen"></i></button>
        <button class="btn btn-sm btn-danger" onclick="deleteOfficer('${o.id}')"><i class="fa-solid fa-trash"></i></button>
      </td>
    `;
    tbody.appendChild(tr);
  });
}

function openAddOfficerModal() {
  document.getElementById('officerId').value = '';
  document.getElementById('officerName').value = '';
  document.getElementById('officerDesignation').value = '';
  document.getElementById('officerDept').value = '';
  document.getElementById('officerPhone').value = '';
  document.getElementById('officerEmail').value = '';
  document.getElementById('officerSourceUrl').value = '';
  document.getElementById('officerVerifyStatus').value = 'Draft';
  openModal('officerModal');
}

function openEditOfficerModal(id) {
  const officers = JSON.parse(localStorage.getItem(STORAGE_KEYS.OFFICERS) || "[]");
  const o = officers.find(item => item.id === id);
  if (!o) return;

  document.getElementById('officerId').value = o.id;
  document.getElementById('officerName').value = o.name;
  document.getElementById('officerDesignation').value = o.designation;
  document.getElementById('officerDept').value = o.department;
  document.getElementById('officerPhone').value = o.phone;
  document.getElementById('officerEmail').value = o.email;
  document.getElementById('officerSourceUrl').value = o.sourceUrl;
  document.getElementById('officerVerifyStatus').value = o.status;
  openModal('officerModal');
}

function saveOfficerForm() {
  const id = document.getElementById('officerId').value;
  const name = document.getElementById('officerName').value.trim();
  const designation = document.getElementById('officerDesignation').value.trim();
  const department = document.getElementById('officerDept').value.trim();
  const phone = document.getElementById('officerPhone').value.trim();
  const email = document.getElementById('officerEmail').value.trim();
  const sourceUrl = document.getElementById('officerSourceUrl').value.trim();
  const status = document.getElementById('officerVerifyStatus').value;

  if (!name || !designation || !phone) {
    alert("कृपया नाम, पदनाम एवं मोबाईल नंबर दर्ज करें।");
    return;
  }

  const officers = JSON.parse(localStorage.getItem(STORAGE_KEYS.OFFICERS) || "[]");

  if (id) {
    const idx = officers.findIndex(o => o.id === id);
    if (idx !== -1) {
      officers[idx] = { id, name, designation, department, phone, email, sourceUrl, status };
      logAuditAction(`अधिकारी विवरण अद्यतन किया गया: ${name}`, id);
    }
  } else {
    const newOff = {
      id: "OFF-" + Math.floor(300 + Math.random() * 700),
      name, designation, department, phone, email, sourceUrl, status
    };
    officers.unshift(newOff);
    logAuditAction(`नया अधिकारी दर्ज किया गया: ${name}`, newOff.id);
  }

  localStorage.setItem(STORAGE_KEYS.OFFICERS, JSON.stringify(officers));
  closeModal('officerModal');
  renderOfficersTable();
  renderOverview();
}

function deleteOfficer(id) {
  if (!confirm("क्या आप इस अधिकारी का विवरण हटाना चाहते हैं?")) return;
  let officers = JSON.parse(localStorage.getItem(STORAGE_KEYS.OFFICERS) || "[]");
  officers = officers.filter(o => o.id !== id);
  localStorage.setItem(STORAGE_KEYS.OFFICERS, JSON.stringify(officers));
  logAuditAction(`अधिकारी विवरण हटाया गया: ${id}`, id);
  renderOfficersTable();
  renderOverview();
}

function triggerOfficerEmail(email, name) {
  if (!email) {
    alert("इस अधिकारी की ईमेल आईडी उपलब्ध नहीं है।");
    return;
  }
  const subject = encodeURIComponent("टीम गोपालसिंह हरनावदा गजा - जनसमस्या समन्वय");
  const body = encodeURIComponent(`आदरणीय ${name} जी,\n\nटीम गोपालसिंह हरनावदा गजा जनसेवा मंच की ओर से सादर प्रणाम। क्षेत्र की जनसमस्याओं के त्वरित निस्तारण हेतु यह सन्देश प्रेषित किया जा रहा है।\n\nधन्यवाद।`);
  window.location.href = `mailto:${email}?subject=${subject}&body=${body}`;
  logAuditAction(`अधिकारी ${name} को ईमेल ट्रिगर भेजा गया`, email);
}

// --- 8. ELECTION DATA CENTER MODULE ---
function renderBoothsTable() {
  const booths = JSON.parse(localStorage.getItem(STORAGE_KEYS.BOOTHS) || "[]");
  const tbody = document.querySelector('#boothsTable tbody');
  if (!tbody) return;
  tbody.innerHTML = '';

  booths.forEach(b => {
    const tr = document.createElement('tr');
    tr.innerHTML = `
      <td><strong>बूथ ${b.boothNo}</strong></td>
      <td>${b.name}</td>
      <td><strong>${b.totalVoters}</strong></td>
      <td>${b.maleVoters} / ${b.femaleVoters}</td>
      <td><span class="badge badge-verified">${b.turnoutPercent}</span></td>
      <td><small style="color: var(--text-muted);">${b.issues}</small></td>
      <td>
        <button class="btn btn-sm btn-outline-gold" onclick="alert('बूथ ${b.boothNo} का एग्रीगेटेड डेटा सम्पादित करने हेतु सुपर एडमिन अनुमति आवश्यक है।')"><i class="fa-solid fa-pen"></i></button>
      </td>
    `;
    tbody.appendChild(tr);
  });
}

function simulateCsvExport() {
  const booths = JSON.parse(localStorage.getItem(STORAGE_KEYS.BOOTHS) || "[]");
  let csvContent = "data:text/csv;charset=utf-8,BoothNo,BoothName,TotalVoters,Male,Female,TurnoutPercent,LocalIssues\n";
  booths.forEach(b => {
    csvContent += `"${b.boothNo}","${b.name}","${b.totalVoters}","${b.maleVoters}","${b.femaleVoters}","${b.turnoutPercent}","${b.issues}"\n`;
  });
  const encodedUri = encodeURI(csvContent);
  const link = document.createElement("a");
  link.setAttribute("href", encodedUri);
  link.setAttribute("download", "AC-198_Jhalrapatan_Booth_Summary.csv");
  document.body.appendChild(link);
  link.click();
  document.body.removeChild(link);
  logAuditAction("AC-198 बूथ समरी CSV एक्सपोर्ट की गई", "Election Data");
}

// --- 9. SOCIAL MEDIA MANAGER MODULE ---
function renderSocialMediaTable() {
  const socials = JSON.parse(localStorage.getItem(STORAGE_KEYS.SOCIALS) || "[]");
  const tbody = document.querySelector('#socialMediaTable tbody');
  if (!tbody) return;
  tbody.innerHTML = '';

  socials.forEach(s => {
    const tr = document.createElement('tr');
    tr.innerHTML = `
      <td><i class="${getSocialIcon(s.platform)}" style="font-size: 1.2rem; color: var(--gold-primary);"></i> ${s.platform}</td>
      <td><strong>${s.title}</strong></td>
      <td><a href="${s.link.startsWith('http') ? s.link : '#'}" target="_blank" style="color: #60A5FA;">${s.link}</a></td>
      <td>
        <button class="btn btn-sm btn-${s.active ? 'primary' : 'secondary'}" onclick="toggleSocialStatus('${s.id}')">
          ${s.active ? 'सक्रिय (Active)' : 'निष्क्रिय (Disabled)'}
        </button>
      </td>
      <td>
        <button class="btn btn-sm btn-danger" onclick="deleteSocialItem('${s.id}')"><i class="fa-solid fa-trash"></i></button>
      </td>
    `;
    tbody.appendChild(tr);
  });
}

function openAddSocialModal() {
  document.getElementById('socialId').value = '';
  document.getElementById('socialTitle').value = '';
  document.getElementById('socialLink').value = '';
  document.getElementById('socialPlatform').value = 'WhatsApp';
  document.getElementById('socialActive').value = 'true';
  openModal('socialModal');
}

function saveSocialForm() {
  const platform = document.getElementById('socialPlatform').value;
  const title = document.getElementById('socialTitle').value.trim();
  const link = document.getElementById('socialLink').value.trim();
  const active = document.getElementById('socialActive').value === 'true';

  if (!title || !link) {
    alert("कृपया शीर्षक एवं लिंक/नंबर दर्ज करें।");
    return;
  }

  const socials = JSON.parse(localStorage.getItem(STORAGE_KEYS.SOCIALS) || "[]");
  const newSocial = {
    id: "SOC-" + Math.floor(10 + Math.random() * 90),
    platform, title, link, active
  };
  socials.unshift(newSocial);
  localStorage.setItem(STORAGE_KEYS.SOCIALS, JSON.stringify(socials));
  logAuditAction(`नया सोशल चैनल जोड़ा गया: ${title}`, newSocial.id);
  closeModal('socialModal');
  renderSocialMediaTable();
  renderOverview();
}

function toggleSocialStatus(id) {
  const socials = JSON.parse(localStorage.getItem(STORAGE_KEYS.SOCIALS) || "[]");
  const idx = socials.findIndex(s => s.id === id);
  if (idx !== -1) {
    socials[idx].active = !socials[idx].active;
    localStorage.setItem(STORAGE_KEYS.SOCIALS, JSON.stringify(socials));
    renderSocialMediaTable();
    renderOverview();
  }
}

function deleteSocialItem(id) {
  let socials = JSON.parse(localStorage.getItem(STORAGE_KEYS.SOCIALS) || "[]");
  socials = socials.filter(s => s.id !== id);
  localStorage.setItem(STORAGE_KEYS.SOCIALS, JSON.stringify(socials));
  renderSocialMediaTable();
  renderOverview();
}

// --- 10. VERIFICATION WORKFLOW QUEUE MODULE ---
function renderVerificationQueue() {
  const officers = JSON.parse(localStorage.getItem(STORAGE_KEYS.OFFICERS) || "[]");
  const devWorks = JSON.parse(localStorage.getItem(STORAGE_KEYS.DEV_WORKS) || "[]");

  const unverifiedOfficers = officers.filter(o => o.status === 'Draft').map(o => ({
    id: o.id, type: 'Government Officer', title: o.name + " (" + o.designation + ")", sourceUrl: o.sourceUrl, raw: o
  }));

  const unverifiedDev = devWorks.filter(d => !d.verified).map(d => ({
    id: d.id, type: 'Development Work', title: d.title, sourceUrl: d.sourceUrl, raw: d
  }));

  const queue = [...unverifiedOfficers, ...unverifiedDev];
  const tbody = document.querySelector('#verificationQueueTable tbody');
  if (!tbody) return;
  tbody.innerHTML = '';

  if (queue.length === 0) {
    tbody.innerHTML = `<tr><td colspan="6" style="text-align: center; color: var(--text-muted); padding: 20px;">सत्यापन कतार में कोई लंबित प्रविष्टि नहीं है।</td></tr>`;
    return;
  }

  queue.forEach(item => {
    const tr = document.createElement('tr');
    tr.innerHTML = `
      <td><strong>${item.id}</strong><br><small style="color: var(--gold-light);">${item.type}</small></td>
      <td>${item.title}</td>
      <td>${new Date().toLocaleDateString('hi-IN')}</td>
      <td><a href="${item.sourceUrl}" target="_blank" style="color: #60A5FA; font-size: 0.8rem;"><i class="fa-solid fa-arrow-up-right-from-square"></i> स्रोत जांचें</a></td>
      <td><span class="badge badge-draft">Draft (लंबित)</span></td>
      <td>
        <button class="btn btn-sm btn-primary" onclick="approveVerification('${item.id}', '${item.type}')"><i class="fa-solid fa-check"></i> सत्यापित एवं प्रकाशित करें</button>
      </td>
    `;
    tbody.appendChild(tr);
  });
}

function approveVerification(id, type) {
  if (type === 'Government Officer') {
    const officers = JSON.parse(localStorage.getItem(STORAGE_KEYS.OFFICERS) || "[]");
    const idx = officers.findIndex(o => o.id === id);
    if (idx !== -1) {
      officers[idx].status = 'Verified';
      localStorage.setItem(STORAGE_KEYS.OFFICERS, JSON.stringify(officers));
    }
  } else if (type === 'Development Work') {
    const devWorks = JSON.parse(localStorage.getItem(STORAGE_KEYS.DEV_WORKS) || "[]");
    const idx = devWorks.findIndex(d => d.id === id);
    if (idx !== -1) {
      devWorks[idx].verified = true;
      localStorage.setItem(STORAGE_KEYS.DEV_WORKS, JSON.stringify(devWorks));
    }
  }
  logAuditAction(`प्रविष्टि ${id} सत्यापित एवं प्रकाशित की गई`, id);
  renderAllViews();
}

// --- 11. AUDIT LOGS MODULE ---
function renderAuditLogs() {
  const logs = JSON.parse(localStorage.getItem(STORAGE_KEYS.AUDIT_LOGS) || "[]");
  const container = document.getElementById('auditLogsTimeline');
  if (!container) return;
  container.innerHTML = '';

  logs.forEach(l => {
    const div = document.createElement('div');
    div.className = 'audit-item';
    div.innerHTML = `
      <div class="audit-icon"><i class="fa-solid fa-user-gear"></i></div>
      <div class="audit-details">
        <div class="audit-meta">
          <span class="audit-admin">${l.adminId}</span>
          <span class="audit-time"><i class="fa-regular fa-clock"></i> ${l.timestamp}</span>
        </div>
        <div class="audit-action">${l.action} <span style="color: var(--gold-light); font-size: 0.75rem;">(Target: ${l.target})</span></div>
      </div>
    `;
    container.appendChild(div);
  });
}

// --- 12. REPORTS & EXPORT GENERATOR ---
function exportData(moduleType, format) {
  let data = [];
  let filename = `Report_${moduleType}_${Date.now()}`;

  if (moduleType === 'complaints') {
    data = JSON.parse(localStorage.getItem(STORAGE_KEYS.COMPLAINTS) || "[]");
  } else if (moduleType === 'dev_works') {
    data = JSON.parse(localStorage.getItem(STORAGE_KEYS.DEV_WORKS) || "[]");
  } else if (moduleType === 'officers') {
    data = JSON.parse(localStorage.getItem(STORAGE_KEYS.OFFICERS) || "[]");
  }

  if (format === 'csv') {
    if (data.length === 0) { alert("निर्यात हेतु डेटा उपलब्ध नहीं है।"); return; }
    const keys = Object.keys(data[0]);
    let csv = keys.join(",") + "\n";
    data.forEach(row => {
      csv += keys.map(k => `"${String(row[k] || '').replace(/"/g, '""')}"`).join(",") + "\n";
    });
    const blob = new Blob(["\uFEFF" + csv], { type: "text/csv;charset=utf-8;" });
    const url = URL.createObjectURL(blob);
    const link = document.createElement("a");
    link.href = url;
    link.download = filename + ".csv";
    link.click();
    logAuditAction(`${moduleType} CSV रिपोर्ट डाउनलोड की गई`, format);
  } else if (format === 'pdf') {
    const printWindow = window.open('', '_blank');
    printWindow.document.write(`
      <html>
        <head>
          <title>टीम गोपालसिंह - ${moduleType.toUpperCase()} रिपोर्ट</title>
          <style>
            body { font-family: sans-serif; padding: 20px; color: #101E3D; }
            h1 { color: #D4AF37; }
            table { width: 100%; border-collapse: collapse; margin-top: 15px; }
            th, td { border: 1px solid #ccc; padding: 8px; text-align: left; font-size: 12px; }
            th { background: #101E3D; color: #fff; }
          </style>
        </head>
        <body>
          <h1>टीम गोपालसिंह – हरनावदा गजा</h1>
          <h2>प्रशासनिक रिपोर्ट: ${moduleType}</h2>
          <p>दिनांक: ${new Date().toLocaleString('hi-IN')}</p>
          <table>
            <thead>
              <tr>${Object.keys(data[0] || {}).map(k => `<th>${k}</th>`).join('')}</tr>
            </thead>
            <tbody>
              ${data.map(row => `<tr>${Object.values(row).map(v => `<td>${v}</td>`).join('')}</tr>`).join('')}
            </tbody>
          </table>
        </body>
      </html>
    `);
    printWindow.document.close();
    printWindow.focus();
    setTimeout(() => { printWindow.print(); }, 500);
    logAuditAction(`${moduleType} PDF/Print रिपोर्ट जेनरेट की गई`, format);
  }
}

// --- 13. APP SETTINGS FORM HANDLER ---
function setupSettingsHandler() {
  const form = document.getElementById('appSettingsForm');
  if (!form) return;

  const current = JSON.parse(localStorage.getItem(STORAGE_KEYS.SETTINGS) || "{}");
  if (current.siteName) document.getElementById('settingSiteName').value = current.siteName;
  if (current.samparkUrl) document.getElementById('settingSamparkUrl').value = current.samparkUrl;
  if (current.disclaimerText) document.getElementById('settingDisclaimerText').value = current.disclaimerText;
  if (current.helpline) document.getElementById('settingHelpline').value = current.helpline;

  form.onsubmit = function(e) {
    e.preventDefault();
    const updated = {
      siteName: document.getElementById('settingSiteName').value.trim(),
      samparkUrl: document.getElementById('settingSamparkUrl').value.trim(),
      disclaimerText: document.getElementById('settingDisclaimerText').value.trim(),
      helpline: document.getElementById('settingHelpline').value.trim()
    };
    localStorage.setItem(STORAGE_KEYS.SETTINGS, JSON.stringify(updated));
    document.getElementById('disclaimerText').innerHTML = `${updated.disclaimerText} <a href="${updated.samparkUrl}" target="_blank">राजस्थान सम्पर्क पोर्टल (181)</a>`;
    logAuditAction("एप्लिकेशन सेटिंग्स अद्यतन की गई", "Settings");
    alert("सेटिंग्स सफलता पूर्वक सुरक्षित कर ली गई हैं।");
  };
}

// --- 14. MODAL UTILITIES ---
function openModal(modalId) {
  const modal = document.getElementById(modalId);
  if (modal) modal.classList.add('active');
}

function closeModal(modalId) {
  const modal = document.getElementById(modalId);
  if (modal) modal.classList.remove('active');
}

// --- 15. INITIALIZATION & EVENT LISTENERS ---
document.addEventListener('DOMContentLoaded', () => {
  // Navigation Links Click
  const navLinks = document.querySelectorAll('.sidebar-nav .nav-link');
  navLinks.forEach(link => {
    link.addEventListener('click', (e) => {
      e.preventDefault();
      const viewId = link.getAttribute('data-view');
      if (viewId) switchView(viewId);
    });
  });

  // Mobile Sidebar Toggle
  const mobileBtn = document.getElementById('mobileToggleBtn');
  if (mobileBtn) {
    mobileBtn.addEventListener('click', () => {
      document.getElementById('sidebar').classList.toggle('mobile-open');
    });
  }

  // RBAC Switcher Change
  const rbacSelect = document.getElementById('rbacSelect');
  if (rbacSelect) {
    rbacSelect.addEventListener('change', (e) => {
      currentRoleKey = e.target.value;
      localStorage.setItem(STORAGE_KEYS.ROLE, currentRoleKey);
      logAuditAction(`प्रशासनिक रोल बदला गया: ${currentRoleKey}`, "RBAC");
      applyRBAC();
    });
  }

  // Live Clock
  setInterval(() => {
    const timeElem = document.getElementById('timeString');
    if (timeElem) {
      timeElem.innerText = new Date().toLocaleTimeString('hi-IN');
    }
  }, 1000);

  // Button Listeners
  document.getElementById('addComplaintBtn')?.addEventListener('click', () => {
    alert("नई शिकायत पंजीकरण हेतु नागरिक पोर्टल अथवा शिकायत फॉर्म का उपयोग करें। एडमिन सीधे मौजूदा शिकायतों पर कार्रवाई कर सकते हैं।");
  });

  document.getElementById('addDevWorkBtn')?.addEventListener('click', openAddDevWorkModal);
  document.getElementById('addOfficerBtn')?.addEventListener('click', openAddOfficerModal);
  document.getElementById('addSocialBtn')?.addEventListener('click', openAddSocialModal);
  document.getElementById('csvExportSimulatorBtn')?.addEventListener('click', simulateCsvExport);

  // Filters
  document.getElementById('complaintWardFilter')?.addEventListener('change', renderComplaintsTable);
  document.getElementById('complaintStatusFilter')?.addEventListener('change', renderComplaintsTable);

  // Settings
  setupSettingsHandler();

  // Initial Apply & Render
  applyRBAC();
  renderAllViews();
});
