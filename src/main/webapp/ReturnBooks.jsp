<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en" data-bs-theme="light">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="icon" type="image/x-icon" href="logo2.jpg">
    <title>Return Books</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11/dist/sweetalert2.min.css">
    <style>
        :root {
            --primary-color: #4e73df;
            --secondary-color: #858796;
            --success-color: #1cc88a;
            --warning-color: #f6c23e;
            --danger-color: #e74a3b;
            --info-color: #36b9cc;
            --card-bg-light: #ffffff;
            --card-bg-dark: #16213e;
            --text-light: #212529;
            --text-dark: #f8f9fa;
            --body-bg-light: #f8f9fa;
            --body-bg-dark: #1a1a2e;
            --border-color-light: #dee2e6;
            --border-color-dark: #495057;
        }

        [data-bs-theme="dark"] {
            --bs-body-bg: var(--body-bg-dark);
            --bs-body-color: var(--text-dark);
            --card-bg: var(--card-bg-dark);
            --primary-color: #5a67d8;
            --border-color: var(--border-color-dark);
        }

        [data-bs-theme="light"] {
            --bs-body-bg: var(--body-bg-light);
            --bs-body-color: var(--text-light);
            --card-bg: var(--card-bg-light);
            --border-color: var(--border-color-light);
        }

        body {
            background-color: var(--bs-body-bg);
            color: var(--bs-body-color);
            transition: all 0.3s ease;
        }

        .card {
            background-color: var(--card-bg);
            border: none;
            border-radius: 0.75rem;
            box-shadow: 0 0.25rem 0.75rem rgba(0, 0, 0, 0.1);
        }

        .issue-details-container {
            border-left: 4px solid var(--primary-color);
            padding-left: 1.5rem;
        }

        .detail-section {
            margin-bottom: 1.5rem;
        }

        .detail-section-title {
            font-size: 1.25rem;
            font-weight: 600;
            color: var(--primary-color);
            margin-bottom: 0.75rem;
            border-bottom: 1px solid var(--border-color);
            padding-bottom: 0.5rem;
        }

        .detail-item {
            display: flex;
            margin-bottom: 0.5rem;
        }

        .detail-label {
            font-weight: 500;
            min-width: 120px;
            color: var(--secondary-color);
        }

        .detail-value {
            flex: 1;
        }

        .due-date-picker {
            max-width: 300px;
            margin-top: 1.5rem;
        }

        .theme-toggle-btn {
            transition: transform 0.3s;
        }
        
        .theme-toggle-btn:hover {
            transform: rotate(15deg);
        }
        
        .uppercase-input {
            text-transform: uppercase;
        }
        
        .status-badge {
            padding: 5px 10px;
            border-radius: 20px;
            font-size: 0.85rem;
            font-weight: 600;
            text-transform: uppercase;
        }
        
        .status-pending {
            background-color: var(--info-color);
            color: white;
        }
        
        .status-ondue {
            background-color: var(--success-color);
            color: white;
        }
        
        .status-overdue {
            background-color: var(--warning-color);
            color: #000;
        }
        
        .status-defaulter {
            background-color: var(--danger-color);
            color: white;
        }
        
        .status-returned {
            background-color: var(--secondary-color);
            color: white;
        }
        
        .btn-renew {
            background-color: var(--warning-color);
            color: #000;
            border: none;
        }
        
        .btn-renew:hover {
            background-color: #dda20a;
            color: #000;
        }
        
        .fine-amount {
            color: var(--danger-color);
            font-weight: bold;
        }
        
        .card-status-pending {
            border-left: 5px solid var(--info-color);
        }
        
        .card-status-ondue {
            border-left: 5px solid var(--success-color);
        }
        
        .card-status-overdue {
            border-left: 5px solid var(--warning-color);
        }
        
        .card-status-defaulter {
            border-left: 5px solid var(--danger-color);
        }
        
        .card-status-returned {
            border-left: 5px solid var(--secondary-color);
        }
    </style>
</head>
<body>
    <div class="container py-4">
        <div class="row mb-4">
            <div class="col-12">
                <div class="d-flex justify-content-between align-items-center">
                    <button class="btn btn-outline-primary" onclick="window.history.back()">
                        <i class="fas fa-arrow-left me-2"></i>Back
                    </button>
                    <h2 class="text-center mb-0 fw-bold" style="color: var(--primary-color);">
                        <i class="fas fa-book-return me-2"></i>Book Return
                    </h2>
                    <button id="themeToggle" class="btn btn-outline-secondary theme-toggle-btn">
                        <i class="fas fa-moon"></i>
                    </button>
                </div>
            </div>
        </div>

        <div class="row justify-content-center">
            <div class="col-lg-8">
                <div class="card shadow-sm mb-4">
                    <div class="card-body">
                        <form id="returnForm">
                            <div class="row g-3">
                                <div class="col-md-6">
                                    <label class="form-label">Student CRN</label>
                                    <div class="input-group">
                                        <span class="input-group-text"><i class="fas fa-id-card"></i></span>
                                        <input type="text" class="form-control uppercase-input" id="crn" required>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label">Accession Number</label>
                                    <div class="input-group">
                                        <span class="input-group-text"><i class="fas fa-barcode"></i></span>
                                        <input type="text" class="form-control" id="accessionNo" required>
                                    </div>
                                </div>
                                <div class="col-12">
                                    <div class="d-flex justify-content-end gap-2">
                                        <button type="button" id="resetBtn" class="btn btn-outline-secondary">
                                            <i class="fas fa-undo me-2"></i>Reset
                                        </button>
                                        <button type="button" id="viewBtn" class="btn btn-primary">
                                            <i class="fas fa-eye me-2"></i>View Details
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </form>
                    </div>
                </div>

                <div class="card shadow-sm mb-4" id="resultCard" style="display:none;">
                    <div class="card-body">
                        <h4 class="card-title mb-4" style="color: var(--primary-color);">
                            <i class="fas fa-info-circle me-2"></i>Issue Details
                        </h4>
                        
                        <div class="issue-details-container">
                            <!-- Student Details Section -->
                            <div class="detail-section">
                                <div class="detail-section-title">
                                    <i class="fas fa-user-graduate me-2"></i>Student Details
                                </div>
                                <div class="detail-item">
                                    <span class="detail-label">Name:</span>
                                    <span class="detail-value" id="studentName"></span>
                                </div>
                                <div class="detail-item">
                                    <span class="detail-label">Contact:</span>
                                    <span class="detail-value" id="studentContact"></span>
                                </div>
                                <div class="detail-item">
                                    <span class="detail-label">Course:</span>
                                    <span class="detail-value" id="studentCourse"></span>
                                </div>
                            </div>
                            
                            <!-- Book Details Section -->
                            <div class="detail-section">
                                <div class="detail-section-title">
                                    <i class="fas fa-book me-2"></i>Book Details
                                </div>
                                
                                <div class="detail-item">
                                    <span class="detail-label">Title:</span>
                                    <span class="detail-value" id="bookTitle"></span>
                                </div>
                                <div class="detail-item">
                                    <span class="detail-label">Author:</span>
                                    <span class="detail-value" id="bookAuthor"></span>
                                </div>
                                <div class="detail-item">
                                    <span class="detail-label">Edition:</span>
                                    <span class="detail-value" id="bookEdition"></span>
                                </div>
                            </div>
                            
                            <!-- Issue Details Section -->
                            <div class="detail-section">
                                <div class="detail-section-title">
                                    <i class="fas fa-calendar-alt me-2"></i>Issue Details
                                </div>
                                
                                <div class="detail-item">
                                    <span class="detail-label">Issue Date:</span>
                                    <span class="detail-value" id="issueDate"></span>
                                </div>
                                <div class="detail-item">
                                    <span class="detail-label">Due Date:</span>
                                    <span class="detail-value" id="dueDate"></span>
                                </div>
                                <div class="detail-item">
                                    <span class="detail-label">Status:</span>
                                    <span class="detail-value" id="status"></span>
                                </div>
                                <div class="detail-item" id="fineContainer" style="display:none;">
                                    <span class="detail-label">Fine Amount:</span>
                                    <span class="detail-value fine-amount" id="fineAmount"></span>
                                </div>
                                <div class="detail-item" id="daysOverdueContainer" style="display:none;">
                                    <span class="detail-label">Days Overdue:</span>
                                    <span class="detail-value" id="daysOverdue"></span>
                                </div>
                            </div>
                            
                            <!-- Renew Date Section -->
                            <div class="due-date-picker" id="renewDateContainer" style="display:none;">
                                <label class="form-label">
                                    <i class="fas fa-calendar-plus me-2"></i>Select New Due Date
                                </label>
                                <input type="date" class="form-control" id="renewDate" required>
                            </div>
                        </div>
                        
                        <div class="d-flex justify-content-end gap-2 mt-4" id="actionBtnContainer" style="display:none;">
                            <button type="button" id="renewBtn" class="btn btn-renew">
                                <i class="fas fa-sync-alt me-2"></i>Renew Book
                            </button>
                            <button type="button" id="returnBtn" class="btn btn-success">
                                <i class="fas fa-check-circle me-2"></i>Submit Book
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

    <script>
$(document).ready(function() {
    // Theme Toggle Functionality
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

    // Force uppercase for CRN input
    $('#crn').on('input', function() {
        this.value = this.value.toUpperCase();
    });

    // View Details Button
    $('#viewBtn').click(function() {
        const crn = $('#crn').val().trim();
        const accessionNo = $('#accessionNo').val().trim();

        // Clear previous errors
        $('.is-invalid').removeClass('is-invalid');
        $('.invalid-feedback').hide();

        // Validate inputs
        let isValid = true;
        if (!crn) {
            $('#crn').addClass('is-invalid');
            $('#crn').after('<div class="invalid-feedback" id="crnError">CRN is required</div>');
            isValid = false;
        }
        if (!accessionNo) {
            $('#accessionNo').addClass('is-invalid');
            $('#accessionNo').after('<div class="invalid-feedback" id="accessionNoError">Accession number is required</div>');
            isValid = false;
        }

        if (!isValid) {
            return;
        }

        // Show loading state
        const $viewBtn = $(this);
        $viewBtn.prop('disabled', true).html('<i class="fas fa-spinner fa-spin me-2"></i>Loading...');

        $.ajax({
            url: 'FetchReturnData',
            type: 'POST',
            data: { 
                crn: crn, 
                accessionNo: accessionNo 
            },
            dataType: 'json',
            success: function(response) {
                if (response.success) {
                    displayDetails(response);
                    $('#resultCard, #actionBtnContainer').fadeIn();
                    
                    // Set card status based on book status
                    setCardStatus(response.data.status);
                    
                    // Handle buttons based on status
                    if (response.data.status === 'RETURNED' || response.data.status === 'RETURN') {
                        $('#renewBtn, #returnBtn').prop('disabled', true);
                        $('#renewDateContainer').hide();
                    } else if (response.data.status === 'DEFAULTER') {
                        $('#renewBtn, #returnBtn').prop('disabled', true);
                        $('#renewDateContainer').hide();
                        $('#fineContainer, #daysOverdueContainer').show();
                    } else if (response.data.status === 'OVERDUE') {
                        if (response.data.days_overdue > 14) {
                            $('#renewBtn').prop('disabled', true);
                        } else {
                            $('#renewBtn').prop('disabled', false);
                        }
                        $('#returnBtn').prop('disabled', false);
                        $('#fineContainer, #daysOverdueContainer').show();
                        $('#renewDateContainer').hide();
                    } else if (response.data.status === 'ON DUE') {
                        $('#renewBtn').prop('disabled', false);
                        $('#returnBtn').prop('disabled', false);
                        $('#fineContainer, #daysOverdueContainer').hide();
                        $('#renewDateContainer').hide();
                    } else {
                        $('#renewBtn, #returnBtn').prop('disabled', false);
                        const tomorrow = new Date();
                        tomorrow.setDate(tomorrow.getDate() + 1);
                        $('#renewDate').attr('min', tomorrow.toISOString().split('T')[0]);
                    }
                } else {
                    Swal.fire({
                        icon: 'error',
                        title: 'Error',
                        text: response.message || 'No record found',
                        confirmButtonColor: '#4e73df'
                    });
                    $('#resultCard').hide();
                }
            },
            error: function(xhr, status, error) {
                Swal.fire({
                    icon: 'error',
                    title: 'Error',
                    text: 'Failed to fetch details. Please check your connection and try again.',
                    confirmButtonColor: '#4e73df'
                });
            },
            complete: function() {
                $viewBtn.prop('disabled', false).html('<i class="fas fa-eye me-2"></i>View Details');
            }
        });
    });

    function setCardStatus(status) {
        // Remove all status classes first
        $('#resultCard').removeClass('card-status-pending card-status-ondue card-status-overdue card-status-defaulter card-status-returned');
        
        // Normalize status values
        if (status === 'PENDING') status = 'PEND';
        if (status === 'RETURNED') status = 'RETURN';
        
        // Add the appropriate status class
        switch(status) {
            case 'PEND':
                $('#resultCard').addClass('card-status-pending');
                break;
            case 'ON DUE':
                $('#resultCard').addClass('card-status-ondue');
                break;
            case 'OVERDUE':
                $('#resultCard').addClass('card-status-overdue');
                break;
            case 'DEFAULTER':
                $('#resultCard').addClass('card-status-defaulter');
                break;
            case 'RETURN':
                $('#resultCard').addClass('card-status-returned');
                break;
            default:
                $('#resultCard').addClass('card-status-pending');
        }
    }

    function displayDetails(data) {
        // Student Details
        $('#studentName').text(data.data.student_name || 'N/A');
        $('#studentContact').text(data.data.contact || 'N/A');
        $('#studentCourse').text(data.data.course || 'N/A');
        
        // Book Details
        $('#bookTitle').text(data.data.book_title || 'N/A');
        $('#bookAuthor').text(data.data.author || 'N/A');
        $('#bookEdition').text(data.data.edition || 'N/A');
        
        // Issue Details
        $('#issueDate').text(formatDate(data.data.issue_date) || 'N/A');
        $('#dueDate').text(formatDate(data.data.due_date) || 'N/A');
        
        // Status with badge
        let status = data.data.status || 'PEND';
        let statusText = status;
        
        // Normalize status for display
        if (status === 'PEND') statusText = 'PENDING';
        if (status === 'RETURN') statusText = 'RETURNED';
        
        let statusClass = 'status-pending';
        
        switch(status) {
            case 'ON DUE':
                statusClass = 'status-ondue';
                break;
            case 'OVERDUE':
                statusClass = 'status-overdue';
                break;
            case 'DEFAULTER':
                statusClass = 'status-defaulter';
                break;
            case 'RETURN':
                statusClass = 'status-returned';
                break;
            case 'PEND':
            default:
                statusClass = 'status-pending';
        }
        
        $('#status').html(`<span class="status-badge ${statusClass}">${statusText}</span>`);
        
        // Fine amount and days overdue
        if (data.data.fine_amount > 0) {
            $('#fineAmount').text('₹' + data.data.fine_amount.toFixed(2));
            $('#fineContainer').show();
        } else {
            $('#fineContainer').hide();
        }
        
        if (data.data.days_overdue > 0) {
            $('#daysOverdue').text(data.data.days_overdue + ' days');
            $('#daysOverdueContainer').show();
        } else {
            $('#daysOverdueContainer').hide();
        }
        
        // Store data for return/renew
        $('#resultCard').data('issueData', {
            issueId: data.data.issue_id,
            crn: data.data.crn,
            accessionNo: data.data.accession_number,
            currentDueDate: data.data.due_date,
            fineAmount: data.data.fine_amount || 0,
            daysOverdue: data.data.days_overdue || 0,
            status: status
        });
    }
    
    function formatDate(dateString) {
        if (!dateString) return 'N/A';
        const date = new Date(dateString);
        return date.toLocaleDateString('en-IN');
    }

 // Renew Book Button
    $('#renewBtn').click(function() {
        const issueData = $('#resultCard').data('issueData');
        
        // Show renew date container if not already visible
        if ($('#renewDateContainer').is(':hidden')) {
            $('#renewDateContainer').fadeIn();
            return;
        }
        
        const renewDate = $('#renewDate').val();
        
        // Clear previous errors
        $('#renewDate').removeClass('is-invalid');
        $('.invalid-feedback').hide();

        // Validate renew date
        let isValid = true;
        if (!renewDate) {
            $('#renewDate').addClass('is-invalid');
            $('#renewDate').after('<div class="invalid-feedback" id="renewDateError">Please select a new due date</div>');
            isValid = false;
        } else {
            const dateRegex = /^\d{4}-\d{2}-\d{2}$/;
            if (!dateRegex.test(renewDate)) {
                $('#renewDate').addClass('is-invalid');
                $('#renewDate').after('<div class="invalid-feedback" id="renewDateError">Please use YYYY-MM-DD format</div>');
                isValid = false;
            } else {
                const selectedDate = new Date(renewDate);
                const today = new Date();
                today.setHours(0, 0, 0, 0);
                
                if (selectedDate <= today) {
                    $('#renewDate').addClass('is-invalid');
                    $('#renewDate').after('<div class="invalid-feedback" id="renewDateError">New due date must be after today</div>');
                    isValid = false;
                }
            }
        }

        if (!isValid) return;

        const $renewBtn = $(this);
        $renewBtn.prop('disabled', true).html('<i class="fas fa-spinner fa-spin me-2"></i>Processing...');

        issueData.newDueDate = renewDate;

        $.ajax({
            url: 'RenewBook',
            type: 'POST',
            data: issueData,
            dataType: 'json',
            success: function(response) {
                if (response.success) {
                    Swal.fire({
                        icon: 'success',
                        title: 'Success!',
                        text: response.message,
                        confirmButtonColor: '#4e73df'
                    }).then(() => {
                        // Update the displayed status to ISSUED
                        $('#status').html('<span class="status-badge status-ondue">ISSUED</span>');
                        // Update the due date
                        $('#dueDate').text(response.data.new_due_date);
                        // Hide the renew date container
                        $('#renewDateContainer').hide();
                        // Update the stored issue data
                        issueData.status = 'ISSUED';
                        issueData.due_date = response.data.new_due_date;
                        $('#resultCard').data('issueData', issueData);
                        // Set card status to ISSUED (using ondue class)
                        setCardStatus('ISSUED');
                        // Hide fine and days overdue sections
                        $('#fineContainer, #daysOverdueContainer').hide();
                        // Enable both buttons
                        $('#renewBtn, #returnBtn').prop('disabled', false);
                    });
                } else {
                    Swal.fire({
                        icon: 'error',
                        title: 'Error',
                        text: response.message,
                        confirmButtonColor: '#4e73df'
                    });
                }
            },
            error: function(xhr, status, error) {
                Swal.fire({
                    icon: 'error',
                    title: 'Error',
                    text: 'Failed to renew book. Please check your connection and try again.',
                    confirmButtonColor: '#4e73df'
                });
            },
            complete: function() {
                $renewBtn.prop('disabled', false).html('<i class="fas fa-sync-alt me-2"></i>Renew Book');
            }
        });
    });

    // Return Book Button
    $('#returnBtn').click(function() {
        Swal.fire({
            title: 'Confirm Return',
            text: 'Are you sure you want to mark this book as returned?',
            icon: 'question',
            showCancelButton: true,
            confirmButtonColor: '#4e73df',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Yes, return it!'
        }).then((result) => {
            if (result.isConfirmed) {
                const $returnBtn = $(this);
                $returnBtn.prop('disabled', true).html('<i class="fas fa-spinner fa-spin me-2"></i>Processing...');

                const issueData = $('#resultCard').data('issueData');

                $.ajax({
                    url: 'ReturnBook',
                    type: 'POST',
                    data: issueData,
                    dataType: 'json',
                    success: function(response) {
                        if (response.success) {
                            Swal.fire({
                                icon: 'success',
                                title: 'Success!',
                                text: response.message,
                                confirmButtonColor: '#4e73df'
                            }).then(() => {
                                // Refresh the form
                                resetForm();
                            });
                        } else {
                            Swal.fire({
                                icon: 'error',
                                title: 'Error',
                                text: response.message,
                                confirmButtonColor: '#4e73df'
                            });
                        }
                    },
                    error: function(xhr, status, error) {
                        Swal.fire({
                            icon: 'error',
                            title: 'Error',
                            text: 'Failed to return book. Please check your connection and try again.',
                            confirmButtonColor: '#4e73df'
                        });
                    },
                    complete: function() {
                        $returnBtn.prop('disabled', false).html('<i class="fas fa-check-circle me-2"></i>Submit Book');
                    }
                });
            }
        });
    });

    // Reset Button
    $('#resetBtn').click(function() {
        Swal.fire({
            title: 'Reset Form',
            text: 'Are you sure you want to clear all fields?',
            icon: 'warning',
            showCancelButton: true,
            confirmButtonColor: '#4e73df',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Yes, reset it!'
        }).then((result) => {
            if (result.isConfirmed) {
                resetForm();
                Swal.fire(
                    'Reset!',
                    'The form has been reset.',
                    'success'
                );
            }
        });
    });

    function resetForm() {
        // Reset form fields
        $('#returnForm')[0].reset();
        
        // Clear displayed data
        $('#studentName, #studentContact, #studentCourse, #bookTitle, #bookAuthor, #bookEdition, #issueDate, #dueDate, #status, #fineAmount, #daysOverdue').text('');
        
        // Hide result sections
        $('#resultCard, #renewDateContainer, #actionBtnContainer, #fineContainer, #daysOverdueContainer').hide();
        
        // Clear errors
        $('.is-invalid').removeClass('is-invalid');
        $('.invalid-feedback').remove();
        
        // Clear stored data
        $('#resultCard').removeData('issueData');
        
        // Reset date picker
        $('#renewDate').val('');
        
        // Focus on first input field
        $('#crn').focus();
        
        // Remove status classes
        $('#resultCard').removeClass('card-status-pending card-status-ondue card-status-overdue card-status-defaulter card-status-returned');
    }

    // Input validation on blur
    $('#crn, #accessionNo').on('blur', function() {
        const $input = $(this);
        if (!$input.val().trim()) {
            $input.addClass('is-invalid');
            if (!$input.next('.invalid-feedback').length) {
                $input.after('<div class="invalid-feedback">This field is required</div>');
            }
        } else {
            $input.removeClass('is-invalid');
            $input.next('.invalid-feedback').remove();
        }
    });

    // Date input validation
    $('#renewDate').on('change', function() {
        const $input = $(this);
        const renewDate = $input.val();
        
        // Clear previous errors
        $input.removeClass('is-invalid');
        $input.next('.invalid-feedback').remove();
        
        if (!renewDate) return;
        
        // Validate date format
        const dateRegex = /^\d{4}-\d{2}-\d{2}$/;
        if (!dateRegex.test(renewDate)) {
            $input.addClass('is-invalid');
            $input.after('<div class="invalid-feedback">Please use YYYY-MM-DD format</div>');
            return;
        }
        
        // Validate date is in the future
        const selectedDate = new Date(renewDate);
        const today = new Date();
        today.setHours(0, 0, 0, 0);
        
        if (selectedDate <= today) {
            $input.addClass('is-invalid');
            $input.after('<div class="invalid-feedback">New due date must be after today</div>');
        }
    });
});
</script>
</body>
</html>