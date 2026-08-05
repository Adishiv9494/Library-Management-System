<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en" data-bs-theme="light">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="icon" type="image/x-icon" href="logo2.jpg">
    <title>Pending Fines</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11/dist/sweetalert2.min.css">
    <style>
        :root { --primary-color: #4e73df; --secondary-color: #858796; --danger-color: #e74a3b; --warning-color: #f6c23e; }
        [data-bs-theme="dark"] { --bs-body-bg: #1a1a2e; --bs-body-color: #f8f9fa; --card-bg: #16213e; }
        [data-bs-theme="light"] { --bs-body-bg: #f8f9fa; --bs-body-color: #212529; --card-bg: #ffffff; }
        body { background-color: var(--bs-body-bg); color: var(--bs-body-color); transition: all 0.3s ease; }
        .card { background-color: var(--card-bg); border: none; border-radius: 0.75rem; box-shadow: 0 0.25rem 0.75rem rgba(0,0,0,0.1); }
        .table th { background-color: var(--warning-color); color: #000; }
        .fine-amount { font-weight: 600; }
        .fine-critical { color: var(--danger-color); font-weight: 700; }
        .back-btn:hover { transform: translateX(-3px); transition: all 0.3s; }
        .theme-toggle:hover { transform: rotate(15deg); transition: all 0.3s; }
        .badge-pending { background-color: var(--warning-color); color: #000; }
        .badge-defaulter { background-color: var(--danger-color); color: white; }
        .total-fine-box { background: var(--warning-color); color: #000; padding: 10px; border-radius: 8px; font-weight: bold; }
        @media print { .no-print { display: none !important; } }
    </style>
</head>
<body>
    <div class="container py-4">
        <div class="row mb-4">
            <div class="col-12">
                <div class="d-flex justify-content-between align-items-center">
                    <button class="btn btn-outline-primary back-btn no-print" onclick="window.history.back()">
                        <i class="fas fa-arrow-left me-2"></i>Back
                    </button>
                    <h2 class="text-center mb-0 fw-bold" style="color: var(--warning-color);">
                        <i class="fas fa-money-bill-wave me-2"></i>Pending Fines
                    </h2>
                    <div class="d-flex gap-2 no-print">
                        <button class="btn btn-outline-success" id="printPdfBtn"><i class="fas fa-file-pdf me-2"></i>Print</button>
                        <button id="themeToggle" class="btn btn-outline-secondary theme-toggle"><i class="fas fa-moon"></i></button>
                    </div>
                </div>
            </div>
        </div>

        <div class="row justify-content-center">
            <div class="col-lg-12">
                <div class="card shadow-sm mb-4">
                    <div class="card-body">
                        <div class="d-flex justify-content-end mb-3">
                            <div class="total-fine-box">
                                <i class="fas fa-rupee-sign me-1"></i> Total Pending Fine: ₹<span id="totalFineAmount">0.00</span>
                            </div>
                        </div>
                        <div class="table-responsive">
                            <table class="table table-striped table-hover">
                                <thead><tr><th>CRN</th><th>Student Name</th><th>Contact</th><th>Total Fine (₹)</th><th>Status</th></tr></thead>
                                <tbody id="pendingFineBody"><tr><td colspan="5" class="text-center"><i class="fas fa-spinner fa-spin me-2"></i>Loading...</td></tr></tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf/2.5.1/jspdf.umd.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf-autotable/3.5.28/jspdf.plugin.autotable.min.js"></script>
    <script>
        $(document).ready(function() {
            function initTheme() {
                const savedTheme = localStorage.getItem('theme') || 'light';
                $('html').attr('data-bs-theme', savedTheme);
                $('#themeToggle i').removeClass('fa-moon fa-sun').addClass(savedTheme === 'dark' ? 'fa-sun' : 'fa-moon');
            }
            $('#themeToggle').click(function() {
                const currentTheme = $('html').attr('data-bs-theme');
                const newTheme = currentTheme === 'dark' ? 'light' : 'dark';
                $('html').attr('data-bs-theme', newTheme);
                localStorage.setItem('theme', newTheme);
                $('#themeToggle i').removeClass('fa-moon fa-sun').addClass(newTheme === 'dark' ? 'fa-sun' : 'fa-moon');
            });
            initTheme();

            function loadPendingFines() {
                $.ajax({
                    url: 'PendingFineServlet',
                    type: 'POST',
                    dataType: 'json',
                    success: function(response) {
                        if (response.success && response.data.length > 0) {
                            let html = '';
                            let total = 0;
                            response.data.forEach(function(d) {
                                const fine = parseFloat(d.totalFine);
                                total += fine;
                                const isDefaulter = d.status === 'DEFAULTER';
                                const badgeClass = isDefaulter ? 'badge-defaulter' : 'badge-pending';
                                html += '<tr><td>' + d.crn + '</td><td>' + d.name + '</td><td>' + (d.contact || 'N/A') + '</td><td class="fine-amount' + (fine > 500 ? ' fine-critical' : '') + '">₹' + fine.toFixed(2) + '</td><td><span class="badge ' + badgeClass + '">' + d.status + '</span></td></tr>';
                            });
                            $('#pendingFineBody').html(html);
                            $('#totalFineAmount').text(total.toFixed(2));
                        } else {
                            $('#pendingFineBody').html('<tr><td colspan="5" class="text-center">No pending fines found</td></tr>');
                            $('#totalFineAmount').text('0.00');
                        }
                    },
                    error: function() { $('#pendingFineBody').html('<tr><td colspan="5" class="text-center text-danger">Error loading data</td></tr>'); }
                });
            }
            loadPendingFines();

            $('#printPdfBtn').click(function() {
                const { jsPDF } = window.jspdf;
                const doc = new jsPDF('p', 'pt', 'a4');
                const logoUrl = 'logo2.jpg';
                const img = new Image();
                img.src = logoUrl;
                img.onload = function() {
                    const maxWidth = 100;
                    const ratio = maxWidth / img.width;
                    const logoWidth = maxWidth;
                    const logoHeight = img.height * ratio;
                    doc.addImage(img, 'PNG', 40, 20, logoWidth, logoHeight);
                    doc.setFontSize(18);
                    doc.setTextColor(40);
                    doc.setFont("helvetica", "bold");
                    doc.text("Pending Fines", 40 + logoWidth + 20, 20 + (logoHeight / 2));
                    const now = new Date();
                    doc.setFontSize(10);
                    doc.setFont("helvetica", "normal");
                    doc.text("Generated on: " + now.toLocaleString(), 40 + logoWidth + 20, 20 + (logoHeight / 2) + 20);
                    const totalFine = $('#totalFineAmount').text();
                    doc.text("Total Pending Fine: ₹" + totalFine, 40 + logoWidth + 20, 20 + (logoHeight / 2) + 40);
                    doc.setDrawColor(200,200,200);
                    doc.line(40, 20 + logoHeight + 50, doc.internal.pageSize.width - 40, 20 + logoHeight + 50);
                    const headers = ["CRN", "Student Name", "Contact", "Total Fine (₹)", "Status"];
                    const data = [];
                    $('#pendingFineBody tr').each(function() {
                        const rowData = [];
                        $(this).find('td').each(function() {
                            rowData.push($(this).text().trim());
                        });
                        if (rowData.length > 0 && rowData[0] !== 'No pending fines found') data.push(rowData);
                    });
                    doc.autoTable({
                        startY: 20 + logoHeight + 60,
                        head: [headers],
                        body: data,
                        styles: { fontSize: 10, cellPadding: 4 },
                        headStyles: { fillColor: [246,194,62], textColor: 0, fontStyle: 'bold', halign: 'center' },
                        columnStyles: { 0: { halign: 'center' }, 3: { halign: 'right' }, 4: { halign: 'center' } },
                        margin: { top: 20 + logoHeight + 60, left: 40, right: 40 },
                        didDrawPage: function(data) {
                            doc.setFontSize(10);
                            doc.setTextColor(150);
                            doc.text('Page ' + data.pageNumber + ' of ' + doc.internal.getNumberOfPages(), data.settings.margin.left, doc.internal.pageSize.height - 20);
                        }
                    });
                    doc.save("Pending_Fines_" + new Date().toISOString().slice(0,10) + ".pdf");
                    Swal.fire({ icon: 'success', title: 'PDF Generated', text: 'Pending fines exported', timer: 2000, showConfirmButton: false });
                };
                img.onerror = function() {
                    Swal.fire({ icon: 'error', title: 'Error', text: 'Logo not found. PDF generated without logo.' });
                };
            });
        });
    </script>
</body>
</html>